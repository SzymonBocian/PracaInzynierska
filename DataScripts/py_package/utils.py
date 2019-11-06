
from math import factorial
from math import exp

def call_per_hour(n, p):
    """
    """
    return ((n*60) / p)

def traffic_intensity(c, a):
    """
    """
    return ((c*a) / 3600)

def probability_call_wait(A, N):
    """
    Calculate the probability a call has to wait 
    based on Erlang C formula.
    :param A: traffic intensity (in Erlangs)
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
    Calculate temporary level of service.
    :param Pw: probability a call has to wait
    :return SL: acquired level of service
    """
    return (1 - (Pw * exp(-1 * (N - A) * (trgt / aht)))) 

def avg_speed_of_answer(Pw, AHT, N, A):
    """
    """
    return ((Pw * AHT) / (N - A))

def immediately_answer(Pw):
    """
    """
    return (1 - Pw) 

def max_occupancy(N, A, max_occupancy):
    """
    """
    occupancy = A / N

    if max_occupancy >= occupancy:
        return occupancy
    else:
        return A / occupancy

def required_consultant(N, s):
    """
    """
    return (N / (1 - s))