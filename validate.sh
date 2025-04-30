#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Script needs root. Re-running with sudo..."
  exec sudo "$0" "$@"
fi



# Functions
results="{\"maximum_marks\": 60, \"obtained_maximum_marks\": 0, \"tasks\": []}"

if ! command -v jq &> /dev/null; then
    echo "jq not found, installing..."
    sudo apt install -y jq
fi


#---------------------------------------------------------------------Tests-------------------------------------------------------------

#-------------------------------------------------Task 1---------------------------------------------

test1_obtained_marks=0

if grep "designers" "/etc/group"; then
	test1_obtained_marks=$((test1_obtained_marks + 10))
fi


# Final Test Status
if [ "$test1_obtained_marks" -eq 10 ]; then
    test1_status="pass"
    test1_message="User created correctly."
else
    test1_status="fail"
    test1_message="Group designers not found."
fi

results=$(echo "$results" | jq ".tasks += [{\"no\": 1, \"name\": \"Task 1\", \"obtained_marks\": $test1_obtained_marks, \"maximum_marks\": 10, \"message\": \"$test1_message\"}]")
results=$(echo "$results" | jq ".obtained_maximum_marks += $test1_obtained_marks")


#Q-2

test2_obtained_marks=0
expected_gid=2000
actual_gid=$(getent group marketing | cut -d: -f3)

if grep "marketing" "/etc/group"; then
	if [[ "$actual_gid" == "$expected_gid" ]]; then
		test2_obtained_marks=$((test2_obtained_marks + 10))
	fi
fi
# Final Test Status
if [ "$test2_obtained_marks" -eq 10 ]; then
    test2_status="pass"
    test2_message="User created with correct group id."
else
    test2_status="fail"
    test2_message="Tasks failed."
fi


results=$(echo "$results" | jq ".tasks += [{\"no\": 2, \"name\": \"Task 2\", \"obtained_marks\": $test2_obtained_marks, \"maximum_marks\": 10, \"message\": \"$test2_message\"}]")
results=$(echo "$results" | jq ".obtained_maximum_marks += $test2_obtained_marks")


#Q-3

test3_obtained_marks=0
test3_failed_properties=()

if id adminuser &>/dev/null; then
	test3_obtained_marks=$((test3_obtained_marks + 5))
else
	test3_failed_properties+=("User creation")
fi


if grep "admingroup" "/etc/group"; then
        test3_obtained_marks=$((test3_obtained_marks + 5))
else
	test3_failed_properties+=("Group creation")
fi

if getent group admingroup | grep "adminuser"; then
        test3_obtained_marks=$((test3_obtained_marks + 5))
else
        test3_failed_properties+=("User not in group")
fi

if grep "%admingroup ALL=(ALL:ALL) ALL" "/etc/sudoers.d/admin_group"; then
        test3_obtained_marks=$((test3_obtained_marks + 5))
else
        test3_failed_properties+=("Sudo")
fi

# Final Test Status
if [ "$test3_obtained_marks" -eq 20 ]; then
    test3_status="pass"
    test3_message="User has sudo access."
else
    test3_status="fail"
    test3_message="Tasks failed: ${test3_failed_properties[*]}"
fi


# Append to results JSON
results=$(echo "$results" | jq ".tasks += [{\"no\": 3, \"name\": \"Task 3\", \"obtained_marks\": $test3_obtained_marks, \"maximum_marks\": 20, \"message\": \"$test3_message\"}]")
results=$(echo "$results" | jq ".obtained_maximum_marks += $test3_obtained_marks")



#Q-4

test4_obtained_marks=0

if grep "uiux" "/etc/group"; then
        test4_obtained_marks=$((test4_obtained_marks + 10))
fi


# Final Test Status
if [ "$test4_obtained_marks" -eq 10 ]; then
    test4_status="pass"
    test4_message="User renamed correctly."
else
    test4_status="fail"
    test4_message="Group not renamed correctly."
fi

# Append to results JSON
results=$(echo "$results" | jq ".tasks += [{\"no\": 4, \"name\": \"Task 4\", \"obtained_marks\": $test4_obtained_marks, \"maximum_marks\": 10, \"message\": \"$test4_message\"}]")
results=$(echo "$results" | jq ".obtained_maximum_marks += $test4_obtained_marks")




#Q-5

test5_obtained_marks=0
test5_failed_properties=()

group_field=$(ls -l /tmp/example.txt | awk '{print $4}')

if grep "tempgroup" "/etc/group"; then
	test5_failed_properties="Group tempgroup still exists."
else
	if [[ "$group_field" =~ ^[0-9]+$ ]]; then
		test5_obtained_marks=$((test5_obtained_marks+10))
	else
		test5_failed_properties="Changes to file not observed."
	fi
fi

# Final Test Status
if [ "$test5_obtained_marks" -eq 10 ]; then
    test5_status="pass"
    test5_message="User deleted successfully"
else
    test5_status="fail"
    test5_message="$test5_failed_properties"
fi

# Append to results JSON
results=$(echo "$results" | jq ".tasks += [{\"no\": 5, \"name\": \"Task 5\", \"obtained_marks\": $test5_obtained_marks, \"maximum_marks\": 10, \"message\": \"$test5_message\"}]")
results=$(echo "$results" | jq ".obtained_maximum_marks += $test5_obtained_marks")


echo $results | jq

