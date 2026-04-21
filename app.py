import psycopg2
import pandas as pd
import streamlit as st

conn = psycopg2.connect(
        dbname="generator_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
)
st.title('Generate users')

locale = st.selectbox('Locale', ['en_US', 'de_DE'])
seed = st.text_input('Seed', '123')
count = st.text_input('Count', '10')
count = int(count)

if "batch" not in st.session_state:
    st.session_state.batch = 0

st.write(f"Current batch: {st.session_state.batch}")

col1, col2 = st.columns(2)

with col1:
    generate = st.button("Generate")

with col2:
    next_batch = st.button("Next batch")

if next_batch:
    st.session_state.batch += 1

if generate or next_batch:
    query = """
    SELECT *
    FROM generate_series(1, %s) AS gs
    CROSS JOIN LATERAL generate_user(%s, %s, %s, gs);
    """
    df = pd.read_sql(
        query,
        conn,
        params=(count, seed, locale, st.session_state.batch)
    )

    st.dataframe(df)