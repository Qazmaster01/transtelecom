import pytest


def validate_logic(rows, invalid_store, invalid_product, bad_price):
    """
    testvalidate_staging
    """
    if rows == 0:
        raise Exception("Нет строк")
    if invalid_store > 0:
        raise Exception("invalid store")
    if invalid_product > 0:
        raise Exception("invalid product")
    if bad_price > 0:
        raise Exception("bad price")
    return True


def test_no_rows_fail():
    with pytest.raises(Exception):
        validate_logic(0, 0, 0, 0)
def test_invalid_store_fail():
    with pytest.raises(Exception):
        validate_logic(10, 1, 0, 0)

def test_valid_data_pass():
    assert validate_logic(10, 0, 0, 0) is True