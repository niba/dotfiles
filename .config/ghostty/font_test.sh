#!/bin/bash

# ANSI escape codes
NORMAL='\033[0m'
BOLD='\033[1m'
ITALIC='\033[3m'
BOLD_ITALIC='\033[1;3m'

# Function to print text in different styles
print_style() {
  local style=$1
  local text=$2
  echo -e "${style}${text}${NORMAL}"
}

# Test different styles
echo "Testing font styles:"
print_style "$NORMAL" "1. This is normal text"
print_style "$BOLD" "2. This is bold text"
print_style "$ITALIC" "3. This is italic text"
print_style "$BOLD_ITALIC" "4. This is bold italic text"

echo -e "\nNOTE: Italic may not be supported in all terminals."
