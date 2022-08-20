import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

################################################################################
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI
################################################################################

# Cache the contract on load
@st.cache(allow_output_mutation=True)
# Define the load_contract function
def load_contract():

    # Load Art Gallery ABI
    with open(Path('./contracts/compiled/dogregistry_abi.json')) as f:
        registry_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("DOG_REGISTRY_CONTRACT")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=registry_abi
    )
    # Return the contract from the function
    return contract


# Load the contract
contract = load_contract()


################################################################################
# Award Certificate
################################################################################

accounts = w3.eth.accounts
account = accounts[0]
owner_account = st.selectbox("Select Account", options=accounts)
broker_address = st.text_input("Broker Address")
broker_id = st.text_input("Broker ID")
# certificate_details = st.text_input("Certificate Details", value="FinTech Certificate of Completion")
if st.button("Add Broker"):
    contract.functions.addBroker(broker_address, broker_id).transact({'from': account, 'gas': 1000000})

################################################################################
# Display Certificate
################################################################################
display_broker_id = st.text_input("Enter a broker ID to display")
if st.button("Display Broker Address"):
    # Get the certificate owner
    broker_address = contract.functions.brokerID(display_broker_id).call()
    st.write(f"The broker ID was assigned to {broker_address}")

    # Get the certificate's metadata
    registry_uri = contract.functions.brokerAddress(display_broker_id).call()
    st.write(f"The reistry's metadata is {registry_uri}")
    # st.image(f'{registry_uri}')

st.markdown("## Register New Puppy")
puppy_id = st.text_input("Enter the puppy ID")
dame_id = st.text_input("Enter the dame ID")
sire_id = st.text_input("Enter the dog sire ID")
litter_id = st.text_input("Enter the dog litter ID")
litter_size = st.number_input("Enter the litter size", value=0, step=1 )
dog_breed = st.text_input("Enter the dog breed")
birth_date= st.text_input("Enter the dog birth date")

if st.button("Register New Puppy"):
    tx_hash = contract.functions.addDog(puppy_id,dame_id,sire_id,litter_id,litter_size,dog_breed,birth_date).transact({'from': account, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

