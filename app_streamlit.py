# Entry-point shim so `streamlit run app_streamlit.py` works from repo root.
# The actual app UI lives in ui/app_streamlit.py
from ui.app_streamlit import *  # noqa: F401,F403

if __name__ == "__main__":
    # Import side-effects in the UI module register the Streamlit widgets.
    pass