import sys
import os

def assemble(assembly_code):
    '''
    This function takes an assembly code as input and returns the machine code

    Output:
        4 bits for instruction and 6 bits for data    
    '''
    # 
    # iiiidddddd
    # Return the machine code as a string or list of integers

    parse_dict = {
        "ADD": "0000",
        "SUB": "0001",
        "ADDI": "0010",
        "SUBI": "0011",
        "MUL2": "0100",
        "DIV2": "0101",
        "CLR": "0110",
        "RST": "0111",
        "MOV": "1000",
        "JMP": "1001",
        "OUT": "1010",
        "LOAD": "1011",
        "STORE": "1100",
    }

    # Split the assembly code into instruction and data
    instruction, data = assembly_code.split(" ")

    # to be possible write code without uppercase
    instruction = instruction.upper()

    try:
        addres_0, addres_1 = data.split(",") #case the instruction has two address
        addres_0 = int(addres_0,16)
        addres_1 = int(addres_1,16)
        flag_only_one_addres = False
    except:
        data = int(data,16)
        flag_only_one_addres = True #case the instruction has only one addres
    

    if flag_only_one_addres:
        # Convert the instruction to machine code
        machine_code = parse_dict[instruction] + format(data, "06b")
    else:
        # Convert the instruction to machine code
        machine_code = parse_dict[instruction] + format(addres_0, "03b") + format(addres_1, "03b")

    return machine_code

def main(args):

    if len(args) == 1:
        print("Please provide the assembly code as an argument")
        return
    elif len(args) == 2:
        asm_file = args[1]
    else:
        print("Please provide only one argument")
        return


    machine_code = [] # List to store the machine code
    # Read the assembly code from a file or user input
    with open(asm_file) as file:
        for line in file:
            assembly_code = line.strip()
            # Call the assemble function to convert the assembly code to machine code          
            line_machine_code = assemble(assembly_code)
            machine_code.append(line_machine_code)

    # Save the machine code in a txt file
    # Get the current working directory
    current_dir = os.getcwd()

    # Create the path for the machine code file
    machine_code_path = os.path.join(current_dir, "src", "machine_code", "machine_code.txt")

    # Save the machine code in a txt file
    with open(machine_code_path, "w") as file:
        for line in machine_code:
            file.write(line + "\n")    

if __name__ == "__main__":
    args = sys.argv
    main(args)