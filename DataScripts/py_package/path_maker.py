
from os import rename
from os.path import join as join
from os.path import isfile as isfile
from os.path import exists as exists
from os.path import expanduser as expanduser
from datetime import datetime

def find_file(path):
    return path.split("/")[-1]

def find_dir(path):
    if isfile(path):
        return path.split("/")[:-1]
    else:
        return path

class PathMaker:
    """
    Create path to file, validate if path exists.
    """

    def create(self, dir_list):
        """
        """
        path = expanduser("~")

        for d in dir_list:
            path = join(path, d)         
        
        return path

    def validate(self, path):
        """
        """
        return exists(path)

    def move_to_arch(self, path_input, path_arch):
        """
        """
        file_name = find_file(path_input)
        time_stmp = "_" + str(datetime.now())[:10] + "."
        arch_name = "arch_" + file_name.replace(".",time_stmp)

        path_arch = join(path_arch,arch_name)
        rename(path_input, path_arch)

        return (path_arch)

if __name__ == "__main__":

    file_list = [
        "Documents", "CallCenterStaffing",
        "Input", "service_dim.csv"
        ]

    arch_list = [
        "Documents", "CallCenterStaffing",
        "Arch", "calendar"
        ]

    path = PathMaker()

    path_f = path.create(file_list)
    path_a = path.create(arch_list)

    print(path.create(find_dir(path_f))) 

    # if path.validate(path_f) and path.validate(path_a):
    #     print(path_f)
    #     print(path_a)
    #     print(path.move_to_arch(path_f, path_a))
    # else:
    #     print("NOT exists!")
