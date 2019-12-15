
import db_conn
import path_maker

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


if __name__ == "__main__":

    model = ModelParams(100,30,180,0.8,20,0.85,0.3)
