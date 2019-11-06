
import os
from py_module import DbConn

class ModelParams:

    __slots__ = [
        'num_of_calls', 'in_period',
        'avg_handle_time', 'required_service_lvl',
        'trgt_answer_time', 'max_occup', 'shrink'
        ]

    def __init__(
            self, num_of_calls, in_period,
            avg_handle_time, required_service_lvl,
            trgt_answer_time, max_occup, shrink):

        self.num_of_calls         = num_of_calls
        self.in_period            = in_period
        self.avg_handle_time      = avg_handle_time
        self.required_service_lvl = required_service_lvl
        self.trgt_answer_time     = trgt_answer_time
        self.max_occup            = max_occup
        self.shrink               = shrink   

    def path_create(self, dir_list):

        path = os.path.expanduser("~")

        for d in dir_list:
            path = os.path.join(path, d)         
        
        return path

    def path_validate(self, path):

        return os.path.exists(path)


if __name__ == "__main__":

    m = ModelParams(100,30,180,0.8,20,0.85,0.3)

    dir_list = ['Documents', 'CallCenterStaffing', 'DataScripts', 'py_package', 'model.py']

    p = m.path_create(dir_list)
    print(m.path_validate(p))