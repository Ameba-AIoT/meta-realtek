import os
import subprocess
import sys

def create_env_image(input_file, output_file, size):
    command = ['mkenvimage', '-s', size, '-o', output_file, input_file]

    try:
        # Excute: mkenvimage -s 0xC000 -o u-boot-env.bin boot-env.txt
        result = subprocess.run(command, check=True)
        print(f"Environment image created successfully at {output_file}")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while creating the environment image: {e}")
    except FileNotFoundError:
        print("The command 'mkenvimage' was not found. Make sure it is installed and in your PATH.")

def main():
    input_file = 'u-boot-env.txt'  # Default
    output_file = 'u-boot-env.img'  # Default
    size = '0xC000'  # Default

    if '-o' in sys.argv:
        o_index = sys.argv.index('-o')
        if len(sys.argv) > o_index + 1:
            output_file = sys.argv[o_index + 1]
        else:
            print("Usage error: -o option requires an argument.")
            return

    if '-i' in sys.argv:
        i_index = sys.argv.index('-i')
        if len(sys.argv) > i_index + 1:
            input_file = sys.argv[i_index + 1]
        else:
            print("Usage error: -i option requires an argument.")
            return

    if '-s' in sys.argv:
        s_index = sys.argv.index('-s')
        if len(sys.argv) > s_index + 1:
            size = sys.argv[s_index + 1]
        else:
            print("Usage error: -s option requires an argument.")
            return

    if not os.path.isfile(input_file):
        print(f"Input file {input_file} does not exist.")
        return

    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        print(f"Output directory {output_dir} does not exist.")
        return

    create_env_image(input_file, output_file, size)

if __name__ == '__main__':
    main()
