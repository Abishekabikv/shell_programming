#!/bin/bash
#Purpose:Task management system
#Version:1.0
#Created Date: Wednesday 28 June 2023 10:36:06 AM IST
#Modified Date:
#Author name: Abishek K V
#START#

tasks_file="tasks.txt"

#function to display the menu"
display_menu(){

	echo "\n\t\t\tTASK MANAGEMENT SYSTEM"
	echo "1. ADD TASK"
	echo "2. UPDATE TASK"
	echo "3. DELETE TASk"
	echo "4. ASSIGN TASK TO USER"
	echo "5. SET THE PRIORITY"
	echo "6. SET TASK DUE DATE"
	echo "7. CATEGORIZE TASK"
	echo "8. CHANGE TASK STATUS"
	echo "9. LIST TASKS"
	echo "0. EXIT"
	echo

}

#Function to add new task
add_task(){

	echo "Enter task name: "
	read -r task_name

	#task_name=$(zenity --entry --title "Add task" --text "Enter task name : ")

	#check if the task already exists
	if grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task already exists.."
		return
	fi

	echo "Enter the task description:"
	read -r task_description

	echo "$task_name|$task_description|Pending|nil|nil|nil|nil|" >> "$tasks_file"
	echo "$task_name task added successfully.."
}

#Function to update an existing task
update_task(){
	echo "Enter the task name to update : "
	read -r task_name

	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task not found.."
		return
	fi

	echo "Enter new description: "
	read -r task_description

	sed -i "/s^$task_name|.*|/$task_name|$task_description|$status|$user_name|$priority|$due_date|$category/" "$tasks_file"
	echo "$task_name task updated successfully.."

}

#function to delete a task
delete_task(){

	echo "Enter the task name to delete: "
	read -r task_name

	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task not found"
		return
	fi

	sed -i "/^$task_name|/d" "$tasks_file"
	echo "$task_name task deleted successfully"
}

#function to assign a task to user
assign_task(){
	
	echo "Enter the task name to assign: "
	read -r task_name
	
	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task not found"
		return
	fi
	
	echo "enter User name : "
	read -r user_name

	sed -i "s/^$task_name|.*|/$task_name|$task_description|pending|$user_name|nil|nil|nil|/" "$tasks_file"
	echo "$task_name task is assigned to user '$user_name' successfully.."
}

#function to set task priority
set_priority(){

	echo "Enter task name to set priority : "
	read -r task_name

	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file"; then
		echo "$task_name task not found.."
		return
	fi

	echo "Enter priority (High, Medium, Low):"
	read -r priority

	#validate the priority value
	if [[ ! $priority =~ ^(High|Medium|Low)$ ]];then
		echo "Invalid priority value.."
		return
	fi

	sed -i "s/^$task_name|.*|/$task_name|$task_description|pending|$user_name|$priority|nil|nil|/" "$tasks_file"
	echo "$task_name is set to '$priority' successfully.."
}

#function to set task due date
set_due_date(){

	echo "Enter the task name to set due date: "
	read -r task_name

	#check if the task exist
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task not found"
		return
	fi

	echo "Enter Due date (YYYY-MM-DD) :"
	read -r due_date

	#validate the due date format
	if [[ ! $due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]];then
		echo "Invalid due date format.."
		return
	fi

	sed -i "s/^$task_name|.*|/$task_name|$task_description|pending|$user_name|$priority|$due_date|nil|/" "$tasks_file"
	echo "Due date set to '$due_date' success for '$task_name' task..."
}

#Function to categorize a task
categorize_task(){

	echo "Enter a task name for categorize: "
	read -r task_name

	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task is not found.."
		return
	fi

	echo "Enter Category: "
	read -r category

	sed -i "s/^$task_name|.*|/$task_name|$task_description|pending|$user_name|$priority|$due_date|$category|/" "$tasks_file"
	echo "$task_name task categorized as '$category' successsfully.."
}

#function to change task status
change_status(){

	echo "Enter task name to change status: "
	read -r task_name

	#check if the task exists
	if ! grep -q "^$task_name|" "$tasks_file";then
		echo "$task_name task not found"
		return
	fi

	echo "Enter Status (pending, in progress, completed): "
	read -r status

	#validate the status value
	if [[ ! $status =~ ^(pending|in progress|completed)$ ]];then
		echo "Invalid status value: "
		return
	fi

	sed -i "s/^$task_name|.*|/$task_name|$task_description|$status|$user_name|$priority|$due_date|$category|/" "$tasks_file"
	echo "$task_name task status changed to '$status' successfully.."
}

#function to list all tasks
list_tasks(){

	echo "................................................................TASK LIST:................................................................"
	echo
	echo "------------------------------------------------------------------------------------------------------------------------------------------"
	echo "     TASK    |     DESCRIPTION         |     STATUS         |    USER_NAME       |     PRIORITY      |      DUE_DATE     |    CATEGORY   |"
	echo "------------------------------------------------------------------------------------------------------------------------------------------"
	awk -F '|' '{ printf "   %-10s|     %-20s|     %-15s|     %-15s|    %-15s|    %-15s|   %-10s  |\n", $1, $2, $3, $4, $5, $6, $7}' "$tasks_file"
	echo "------------------------------------------------------------------------------------------------------------------------------------------"
}

#main script
while true;do
	display_menu
	echo "Enter your choice: "
	read -r choice
	echo 

	case $choice in
		1)
			add_task
			;;
		2)
			update_task
			;;
		3)
			delete_task
			;;
		4)
			assign_task
			;;
		5)
			set_priority
			;;
		6)
			set_due_date
			;;
		7)
			categorize_task
			;;
		8)
			change_status
			;;
		9)
			list_tasks
			;;
		0)
			echo "Existing..."
			exit 0
			;;
		*)
			echo "Invalid Choice....Please try again.."
			;;
	esac

	echo
done
#END#
