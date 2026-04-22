import psycopg2
import pandas as pd
import streamlit as st
import time

conn = psycopg2.connect(
    "postgresql://postgres.mobdjjxtbmteboxhpejb:0302Ksenya!@aws-0-eu-west-1.pooler.supabase.com:6543/postgres"
)
st.title('Generate users')

locale = st.selectbox('Locale', ['en_US', 'de_DE'])
seed = st.text_input('Seed', "123")
count = st.number_input('Count', value=10, step=10, min_value=1)

if 'batch' not in st.session_state:
    st.session_state.batch = 0

st.write(f'Current batch: {st.session_state.batch}')

col1, col2 = st.columns(2)

with col1:
    generate = st.button('Generate')

with col2:
    next_batch = st.button('Next batch')

if next_batch:
    st.session_state.batch += 1

if generate or next_batch:

    query = """
    SELECT *
    FROM generate_series(1, %s) AS gs
    CROSS JOIN LATERAL generate_user(%s, %s, %s, gs);
    """

    start = time.time()
    df = pd.read_sql(
        query,
        conn,
        params=(count, seed, locale, st.session_state.batch)
    )

    end = time.time()
    st.dataframe(df)

    speed = len(df) / (end - start)
    st.write(f' Speed: {speed:.2f} users/sec')