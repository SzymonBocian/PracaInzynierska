
from math  import ceil
from model import ModelParams
from utils import *

class ErlangC:

    __slots__ = ['param']

    def __init__(self, param):

        self.param = param

    def calculate(self):
        """
        Calculate required number of consultant
        based on Erlang C formula.
        :param self:
        """
        # Input variable initialization
        num_of_calls         = self.param.num_of_calls         
        in_period            = self.param.in_period            
        avg_handle_time      = self.param.avg_handle_time      
        required_service_lvl = self.param.required_service_lvl 
        trgt_answer_time     = self.param.trgt_answer_time     
        max_occup            = self.param.max_occup            
        shrink               = self.param.shrink               

        C = call_per_hour(num_of_calls, in_period)
        A = traffic_intensity(C, avg_handle_time)
        N = int(ceil(A) + 1)
        
        # Init input erlang C parameters
        Pw = probability_call_wait(A, N)
        sl = service_level(Pw, A, N, trgt_answer_time, avg_handle_time)

        # Do until reach required service level
        while sl < required_service_lvl:
            N += 1
            Pw = probability_call_wait(A, N)
            sl = service_level(Pw, A, N, trgt_answer_time, avg_handle_time)
            
        # Calculate other parameters
        ASA = avg_speed_of_answer(Pw, avg_handle_time, N, A)
        CAI = immediately_answer(Pw)
        MO = max_occupancy(N, A, max_occup)
        s = required_consultant(N, shrink)

        a = [round((100 * e), 2) for e in (Pw, sl, ASA, CAI, MO)]
        a.append(s)

        return a


if __name__ == "__main__":

    m = ModelParams(100,30,180,0.8,20,0.85,0.3)

    ec = ErlangC(m)

    print(ec.calculate())
