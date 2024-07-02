# shared_code.sh

# Function to check if required commands are installed
check_commands() {
  local missing=0
  for cmd in "$@"; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "$cmd is required but not installed. Please install $cmd and try again."
      missing=1
    fi
  done

  if [ $missing -eq 1 ]; then
    exit 1
  fi
}


default_profile="harmonate-sandbox"
credentials_file=~/.aws/credentials

# Read the profile names from the credentials file
profile_names=($(awk -F '[][]' '/^\[/ {print $2}' $credentials_file))

# Find the index of the default profile in the array
default_index=$(printf "%s\n" "${profile_names[@]}" | awk -v def="$default_profile" '{if ($0 == def) {print NR-1; exit}}')

# Generate the list of profiles for selection
profile_list=$(printf "%s\n" "${profile_names[@]}" | awk -v def="$default_profile" '{printf "%02d. %s%s\n", NR, $0, (NR==1 && $0==def ? " (default)" : "")}')

# Prompt the user to select a profile
echo "Select an AWS profile:"
echo -e "$profile_list"

# Read the user's selection and validate the input
while true; do
  read -p "Enter the number corresponding to the profile (default: $default_profile): " selection

  # Check if the selection is empty (user hit Enter)
  if [[ -z $selection ]]; then
    selected_profile=$default_profile
    break
  fi

  # Check if the selection is a valid number
  if [[ $selection =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#profile_names[@]}" ]; then
    selected_profile=${profile_names[$((${selection}-1))]}
    break
  else
    echo "Invalid selection. Please enter a valid number."
  fi
done

# Set the AWS_PROFILE variable
export AWS_PROFILE=$selected_profile
echo "AWS profile set to: $AWS_PROFILE"

# Set the default region (change this to your desired default region)
default_region="us-east-1"

# Fetch the list of valid AWS regions
#regions=($(aws ec2 describe-regions --query 'Regions[].RegionName' --output text))
regions=($(aws ec2 describe-regions --query 'Regions[].RegionName' --output json | jq -r '
  .[] | select(startswith("us") or startswith("eu"))' | awk '
{
  split($0, a, "-");
  prefix=a[1];
  number=a[2];
  print prefix, number, $0
}' | sort -k1,1r -k2,2n | awk '{print $3}'
))

# Generate the list of regions for selection
region_list=$(printf "%s\n" "${regions[@]}" | awk -v def="$default_region" '{printf "%02d. %s%s\n", NR, $0, (NR==1 && $0==def ? " (default)" : "")}')

# Prompt the user to select a region
echo "Select an AWS region:"
echo -e "$region_list"

# Read the user's selection and validate the input
while true; do
  read -p "Enter the number corresponding to the region (default: $default_region): " selection

  # Check if the selection is empty (user hit Enter)
  if [[ -z $selection ]]; then
    selected_region=$default_region
    break
  fi

  # Check if the selection is a valid number
  if [[ $selection =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#regions[@]}" ]; then
    selected_region=${regions[$((${selection}-1))]}
    break
  else
    echo "Invalid selection. Please enter a valid number."
  fi
done

# Set the AWS_DEFAULT_REGION variable
export REGION=$selected_region

echo "AWS region set to: $REGION"
