import pytest
import pandas as pd


def transform_sales(df):
    """
    test core.sales
    """
    df = df.sort_values("created_at", ascending=False)
    df = df.drop_duplicates(subset=["sale_id"], keep="first")

    df = df[df["quantity"] != 0]

    df["discount_pct"] = df["discount_pct"].fillna(0)
    df["discount_pct"] = df["discount_pct"].clip(lower=0, upper=100)

    df["revenue"] = df["quantity"] * df["unit_price"] * (1 - df["discount_pct"] / 100)
    df["is_return"] = df["quantity"] < 0
    df["sale_date"] = pd.to_datetime(df["sale_ts"]).dt.date

    return df


def test_deduplication():
    df = pd.DataFrame({
        "sale_id": [1, 1],
        "quantity": [1, 1],
        "unit_price": [100, 100],
        "discount_pct": [0, 0],
        "sale_ts": ["2026-03-29", "2026-03-29"],
        "created_at": ["2026-03-29 10:00", "2026-03-29 12:00"]
    })

    result = transform_sales(df)

    assert len(result) == 1
    assert result.iloc[0]["created_at"] == "2026-03-29 12:00"


def test_discount_clamp():
    df = pd.DataFrame({
        "sale_id": [1, 2],
        "quantity": [1, 1],
        "unit_price": [100, 100],
        "discount_pct": [150, -10],
        "sale_ts": ["2026-03-29", "2026-03-29"],
        "created_at": ["2026-03-29", "2026-03-29"]
    })

    result = transform_sales(df)

    assert result.loc[result["sale_id"] == 1, "discount_pct"].iloc[0] == 100
    assert result.loc[result["sale_id"] == 2, "discount_pct"].iloc[0] == 0


def test_revenue_calculation():
    df = pd.DataFrame({
        "sale_id": [1],
        "quantity": [2],
        "unit_price": [100],
        "discount_pct": [10],
        "sale_ts": ["2026-03-29"],
        "created_at": ["2026-03-29"]
    })

    result = transform_sales(df)

    assert result.iloc[0]["revenue"] == 180 