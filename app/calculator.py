def test_add():
    assert add(4,3) == 6
    assert add(4,2) == 6
    assert add(3,3) == 6
    assert add(1,5) == 6
    assert add(4,4) == 6

def add(number1, number2):
    return number1 + number2
