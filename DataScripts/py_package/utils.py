
from math import factorial
from math import exp
from math  import ceil

def call_per_hour(n, p):
    """
    Calculate amount of calls in hour 
    :param n: number of calls in period of time
    :param p: period of time [min]
    :return: number of calls in one hour
    """
    return ((n*60) / p)

def traffic_intensity(c, aht):
    """
    Calculate traffic intensity in hour 
    :param c: number of calls in hour
    :param aht: average handling time (AHT) [sec]
    :return: traffic intensity [Erlangs]
    """
    return ((c*aht) / 3600)

def probability_call_wait(A, N):
    """
    Calculate the probability a call has to wait 
    based on Erlang C formula.
    :param A: traffic intensity [Erlangs]
    :param N: number of consultant
    :return Pw: probability a call has to wait 
    """
    X = (A**N / factorial(N)) * (N / (N - A))

    Y = 0
    for i in range(N):
        Y += (A**i / factorial(i))

    return (X / (Y + X))


def service_level(Pw, A, N, trgt, aht): 
    """
    Calculate temporary level of service (SL).
    :param Pw: probability a call has to wait
    :param A: traffic intensity [Erlangs]
    :param N: number of consultant
    :param trgt: target answer time [sec]
    :param aht: average handling time (AHT) [sec]
    :return: acquired level of service (SL)
    """
    return (1 - (Pw * exp(-1 * (N - A) * (trgt / aht)))) 

def avg_speed_of_answer(Pw, aht, N, A):
    """
    Calculate average speed of answer for a call [sec].
    :param Pw: probability a call has to wait
    :param aht: average handling time (AHT) [sec]
    :param N: number of consultant
    :param A: traffic intensity [Erlangs]
    :return: 
    """
    return ((Pw * aht) / (N - A))

def immediately_answer(Pw):
    """
    Calculate of probability of immediately answer for a call [sec]
    :param Pw: probability a call has to wait
    :return:
    """
    return (1 - Pw) 

def max_occupancy(N, A, max_occupancy):
    """
    Calculate maximal occupancy of call center
    :param N: number of consultant
    :param A: traffic intensity [Erlangs]
    :param max_occupancy: given maximal call cener occupancy
    :return:
    """
    occupancy = A / N

    if max_occupancy >= occupancy:
        return occupancy
    else:
        return A / occupancy

def required_consultant(N, s):
    """
    Calculate number of required consultant based on traffic intensity
    :param N: number of consultant
    :param s: given level of shrinkage
    :return:
    """
    return ceil(N / (1 - s))

def calculate(
    num_of_calls, in_period,
    avg_handle_time, required_service_lvl,
    trgt_answer_time, max_occup, shrink):
    """
    Calculate required number of consultant
    based on Erlang C formula.
    :param self:
    """

    C = call_per_hour(num_of_calls, in_period) #- deprecated: always in [hour] -> period of time
    # C = num_of_calls
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

    a = [round((100 * e), 2) for e in (Pw, sl, CAI, MO)]
    
    [a.append(round(x,2)) for x in (ASA, s)]

    return a

def variable_list():
    """
    """
    return [probability_call_wait, in_period, avg_handle_time, required_service_lvl, trgt_answer_time, max_occup, shrink]


if __name__ == "__main__":

    print(calculate(200,60,180,0.8,20,0.85,0.3))






















