
from math  import ceil
# from model import ModelParams
# from utils import *

class ErlangC:

    # __slots__ = ['param']

    # __slots__ = [
    #     "num_of_calls", "in_period",           
    #     "avg_handle_time", "required_service_lvl",
    #     "trgt_answer_time", "max_occup", "shrink"              
    #     ]

    def __init__(
        self, num_of_calls, in_period,
        avg_handle_time, required_service_lvl,
        trgt_answer_time, max_occup, shrink
        ):

        self.num_of_calls         = num_of_calls
        self.in_period            = in_period
        self.avg_handle_time      = avg_handle_time
        self.required_service_lvl = required_service_lvl
        self.trgt_answer_time     = trgt_answer_time
        self.max_occup            = max_occup
        self.shrink               = shrink

    def __str__(self):
        return "A: " + str(self.num_of_calls)

    def __repr__(self):
        return ("__repr__")

    # def __init__(self, param):

        # self.param = param

    def calculate(self):
        """
        Calculate required number of consultant
        based on Erlang C formula.
        :param self:
        """
        # Input variable initialization
        # num_of_calls         = self.param.num_of_calls         
        # in_period            = self.param.in_period            
        # avg_handle_time      = self.param.avg_handle_time      
        # required_service_lvl = self.param.required_service_lvl 
        # trgt_answer_time     = self.param.trgt_answer_time     
        # max_occup            = self.param.max_occup            
        # shrink               = self.param.shrink               

        C = call_per_hour(self.num_of_calls, self.in_period)
        A = traffic_intensity(C, self.avg_handle_time)
        N = int(ceil(A) + 1)
        
        # Init input erlang C parameters
        Pw = probability_call_wait(A, N)
        sl = service_level(Pw, A, N, self.trgt_answer_time, self.avg_handle_time)

        # Do until reach required service level
        while sl < self.required_service_lvl:
            N += 1
            Pw = probability_call_wait(A, N)
            sl = service_level(Pw, A, N, self.trgt_answer_time, self.avg_handle_time)
            
        # Calculate other parameters
        ASA = avg_speed_of_answer(Pw, self.avg_handle_time, N, A)
        CAI = immediately_answer(Pw)
        MO = max_occupancy(N, A, self.max_occup)
        s = required_consultant(N, self.shrink)

        a = [round((100 * e), 2) for e in (Pw, sl, ASA, CAI, MO)]
        
        [a.append(round(x,2)) for x in (ASA, s)]

        return a


if __name__ == "__main__":

    # model = ModelParams(100,30,180,0.8,20,0.85,0.3)

    # ec = ErlangC(model)
    ec = ErlangC(200,60,180,0.8,20,0.85,0.3)
    print(ec)
    print(ec.calculate())
