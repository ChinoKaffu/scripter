#!/bin/bash

# Usage: ./menu_script.sh <USERNAME> <CELL_NAME>

USERNAME="$1"
CELL_NAME="$2"

ACTIONS=("basic checks" "runprio1" "runprio2" "ckresults")
PREVIOUSLY_EXECUTED=""

# --- Argument Validation ---
if [ -z "$USERNAME" ] || [ -z "$CELL_NAME" ]; then
    echo "ERROR: Missing required arguments." >&2
    echo "Usage: $0 <USERNAME> <CELL_NAME>"
    exit 1
fi

echo ""
echo "=== Console Management Script ==="
echo "  USER: $USERNAME"
echo "  CELL ID: $CELL_NAME"
echo "================================="
echo ""

PS3="Main Menu > "

select CHOICE in "${ACTIONS[@]}"; do
    ACTION_LABEL=""
    ACTUAL_COMMAND=""
    
    # === Action Mapping ===
    case $CHOICE in
        "basic checks")
            echo -e "\n=== Basic Checks ==="
            CHECKS=("LVS" "GDS" "RGPA" "Back to Main Menu")
            
            OLD_PS3=$PS3
            PS3="Basic Checks > "
            
            select CHECK in "${CHECKS[@]}"; do
                case $CHECK in
                    "LVS")
                        ACTION_LABEL="LVS"
                        ACTUAL_COMMAND="check_lvs $USERNAME $CELL_NAME"
                        break
                        ;;
                    "GDS")
                        ACTION_LABEL="GDS"
                        ACTUAL_COMMAND="check_gds $USERNAME $CELL_NAME"
                        break
                        ;;
                    "RGPA")
                        ACTION_LABEL="RGPA"
                        ACTUAL_COMMAND="check_rgpa $USERNAME $CELL_NAME"
                        break
                        ;;
                    "Back to Main Menu")
                        echo "Returning to main menu..."
                        PS3=$OLD_PS3
                        continue 2 # Exit inner select and continue outer loop
                        ;;
                    *)
                        echo "Invalid selection. Please try again."
                        ;;
                esac
            done
            PS3=$OLD_PS3
            ;;
        "runprio1")
            ACTION_LABEL="runprio1"
            ACTUAL_COMMAND="runprio1 $USERNAME $CELL_NAME"
            ;;
        "runprio2")
            ACTION_LABEL="runprio2"
            ACTUAL_COMMAND="runprio2 $USERNAME $CELL_NAME"
            ;;
        "ckresults")
            ACTION_LABEL="ckresults"
            ACTUAL_COMMAND="ckresults $USERNAME $CELL_NAME"
            ;;
        *)
            echo "Invalid selection. Please enter a number from the list."
            continue
            ;;
    esac

    # --- Execution and History Block ---
    if [ -n "$ACTION_LABEL" ]; then
        echo -e "\n-> Preparing execution for ACTION: $ACTION_LABEL"
        echo "-> Command to execute:"
        echo "   $ACTUAL_COMMAND"
        echo ""
        
        # Confirmation Prompt
        read -r -p "Confirm execution? (y/N): " CONFIRMATION
        
        if [[ "$CONFIRMATION" =~ ^[Yy]$ ]]; then
            echo "Execution confirmed. Proceeding..."
            
            # --- Actual Command Execution ---
            # Uncomment the line below to execute the command.
            # $ACTUAL_COMMAND
	    echo ""
            # --- Simulation Block ---
            if [ $? -eq 0 ]; then
                echo "SUCCESS: Command execution simulated/completed."
                
                if [ -n "$PREVIOUSLY_EXECUTED" ]; then
                    PREVIOUSLY_EXECUTED="$PREVIOUSLY_EXECUTED, $ACTION_LABEL"
                else
                    PREVIOUSLY_EXECUTED="$ACTION_LABEL"
                fi
            else
                echo "FAILURE: Command encountered an error."
            fi
            
        else
            echo "Execution cancelled by user."
        fi

        echo ""
        echo "================================"
        echo "PREVIOUSLY EXECUTED: [ $PREVIOUSLY_EXECUTED ]"
        echo "================================"
        
    fi
done	