#!/bin/bash

# -----------------------------------------------------------------------------
# OPENSUSE CONSOLE SCRIPT - INTERACTIVE ACTION SELECTION (POSITIONAL ARGS)
#
# Usage: ./menu_script.sh <USERNAME> <CELL_NAME>
# -----------------------------------------------------------------------------

# --- Configuration ---

USERNAME="$1"
CELL_NAME="$2"

# Main menu options
ACTIONS=("basic checks" "runprio1" "runprio2" "ckresults" "Exit Menu")

# --- Argument Validation ---

if [ -z "$USERNAME" ] || [ -z "$CELL_NAME" ]; then
    echo "ERROR: Missing required arguments." >&2
    echo "Usage: $0 <USERNAME> <CELL_NAME>"
    exit 1
fi

# --- Menu and Execution ---

echo "--- Console Management Script ---"
echo "CELL ID: $CELL_NAME"
echo "USER: $USERNAME"
echo "-------------------------------"

# Store original IFS and set it to newline ('\n') to force vertical listing of choices
OLD_IFS=$IFS
IFS=$'\n'

# Outer loop for main menu
PS3="Main Menu > "
select CHOICE in "${ACTIONS[@]}"; do
    case $CHOICE in
        "basic checks")
            echo -e "\n--- Submenu: Basic Checks ---"
            # Submenu options
            CHECKS=("LVS" "GDS" "RGPA" "Back to Main Menu")
            
            # Temporarily change prompt for submenu
            OLD_PS3=$PS3
            PS3="Basic Checks > "
            
            # The inner select loop inherits the vertical IFS setting
            select CHECK in "${CHECKS[@]}"; do
                case $CHECK in
                    "LVS")
                        ACTION_LABEL="Basic Check: LVS"
                        # Assumed alias: check_lvs
                        ACTUAL_COMMAND="check_lvs $USERNAME $CELL_NAME"
                        # Break inner loop to proceed to execution block
                        break
                        ;;
                    "GDS")
                        ACTION_LABEL="Basic Check: GDS"
                        # Assumed alias: check_gds
                        ACTUAL_COMMAND="check_gds $USERNAME $CELL_NAME"
                        break
                        ;;
                    "RGPA")
                        ACTION_LABEL="Basic Check: RGPA"
                        # Assumed alias: check_rgpa
                        ACTUAL_COMMAND="check_rgpa $USERNAME $CELL_NAME"
                        break
                        ;;
                    "Back to Main Menu")
                        echo "Returning to main menu..."
                        # Restore main prompt and skip to next iteration of OUTER loop
                        PS3=$OLD_PS3
                        continue 2
                        ;;
                    *)
                        echo "Invalid selection. Please try again."
                        ;;
                esac
            done
            # Restore PS3 if we broke out of inner loop normally
            PS3=$OLD_PS3
            ;;
        "runprio1")
            ACTION_LABEL="Run Prio 1 Deployment"
            ACTUAL_COMMAND="runprio1 $USERNAME $CELL_NAME"
            ;;
        "runprio2")
            ACTION_LABEL="Run Prio 2 Deployment"
            ACTUAL_COMMAND="runprio2 $USERNAME $CELL_NAME"
            ;;
        "ckresults")
            ACTION_LABEL="Check Results"
            ACTUAL_COMMAND="ckresults $USERNAME $CELL_NAME"
            ;;
        "Exit Menu")
            echo "Exiting script. Goodbye!"
            break
            ;;
        *)
            echo "Invalid selection. Please enter a number from the list."
            continue
            ;;
    esac

    # --- Execution Block (Safety Locked: Shared by all valid selections) ---
    echo -e "\n-> Preparing execution for ACTION: $ACTION_LABEL"
    echo "-> Executing command in simulation mode (ECHO ONLY):"
    echo "   $ACTUAL_COMMAND"
    echo ""
    
    # $ACTUAL_COMMAND  # THIS LINE REMAINS COMMENTED OUT TO PREVENT ACTUAL EXECUTION
    
    echo "SIMULATION COMPLETE: The command was printed but not executed."
    echo "-------------------------------"
done

# Restore original IFS before exiting the script environment
IFS=$OLD_IFS

echo ""