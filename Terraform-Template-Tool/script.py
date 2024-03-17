import sys
import os

# List of directories containing template files
template_dirs = [
    "/Users/chappy/bin/DevOps-Scripts-Tools/Terraform"

]

def load_templates():
    """
    Load templates from specified directories, assuming files are named as '<name>.tf'.
    """
    templates = {}
    for dir_path in template_dirs:
        if not os.path.exists(dir_path):
            print(f"Directory {dir_path} does not exist. Skipping.")
            continue
        for file_name in os.listdir(dir_path):
            if file_name.endswith('.tf'):
                template_name = file_name.rsplit('.', 1)[0]
                file_path = os.path.join(dir_path, file_name)
                with open(file_path, 'r') as file:
                    templates[template_name] = file.read()
    return templates

def generate_tf_file(templates, template_name, file_name):
    """
    Generate a .tf file based on a selected template.
    """
    if template_name not in templates:
        print("Template not found. Please choose a valid template.")
        return False

    with open(file_name, "w") as file:
        file.write(templates[template_name])
    print(f"{file_name} has been created with the {template_name} template.")
    return True

def main():
    if len(sys.argv) != 2:
        print("Usage: python scriptname.py <filename.tf>")
        return

    file_name = sys.argv[1].strip()
    if not file_name.endswith('.tf'):
        print("The file name must end with '.tf'. Exiting.")
        return

    templates = load_templates()
    # Extract template name from the file name
    template_name = file_name.rsplit('.', 1)[0]

    if not generate_tf_file(templates, template_name, file_name):
        print("Available templates:")
        for template in templates.keys():
            print(f"- {template}")

if __name__ == "__main__":
    main()

