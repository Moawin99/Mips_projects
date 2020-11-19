import pyperclip

def read_input():
    number_of_registers_needed = int(input("Enter the number of registers you need: "))
    save_ra = input("Save $ra? (y/n)")
    num_of_args = int(input("How many Arguments are there: "))
    if (number_of_registers_needed > 8):
        print("Too many registers")
    else:
        preamble = generate_preamble(number_of_registers_needed, save_ra, num_of_args)
        postamble = generate_postamble(number_of_registers_needed, save_ra)
        print("Preamble")
        print(preamble)
        print("Postamble")
        print(postamble)
        pyperclip.copy(preamble + '\n'+ postamble)


def generate_preamble(number_of_registers_needed, save_ra, num_of_args):
    if save_ra == 'y':
        allocate_space = f"addi $sp, $sp, -{(number_of_registers_needed+1) * 4}\n" 
    else:
        allocate_space = f"\taddi $sp, $sp, -{number_of_registers_needed * 4}\n" 
    preamble_text = ""
    for register in range(0, number_of_registers_needed):
        register_multiple = register * 4
        preamble_text += f"\tsw $s{register}, {register_multiple}($sp)\n"
    if save_ra == "y":
        preamble_text += f"\tsw $ra, {(number_of_registers_needed)*4}($sp)\n"
    for move in range(0, num_of_args):
        preamble_text += f"\tmove $s{move}, $a{move}\n"
    return allocate_space + preamble_text

def generate_postamble(number_of_registers_needed, save_ra):
    if save_ra == 'y':
        allocate_space = f"\taddi $sp, $sp, {(number_of_registers_needed + 1) * 4}\n"
    else:
        allocate_space = f"\taddi $sp, $sp, {number_of_registers_needed * 4}\n"
    postamble_text = ""
    for register in range(0, number_of_registers_needed):
        register_multiple = register * 4
        postamble_text += f"\tlw $s{register}, {register_multiple}($sp)\n"
    if save_ra == "y": 
        postamble_text += f"\tlw $ra, {number_of_registers_needed * 4}($sp)\n"
    return postamble_text + allocate_space


read_input()
