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
selected_account = st.selectbox("Select Account", options=accounts)

st.markdown("## Add Broker")
st.markdown('##### Deployer adds Broker')
broker_address = st.text_input("Broker Address")
broker_id = st.text_input("Broker ID")
# Add broker button
if st.button("Add Broker"):
    tx_hash = contract.functions.addBroker(broker_address, broker_id).transact({'from': selected_account, 'gas': 1000000})
    # view receipt
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

################################################
# Add Veterinarian Doctor
################################################
st.markdown("## Add Veterinarian Doctor")
st.markdown('##### Broker adds Doctor')
veterinarian_address = st.text_input("Veterinarian  Address")
veterinarian_id = st.text_input("Dog Veterinarian  ID")

# Add Veterinarian button
if st.button("Add Veterinarian Doctor"):
    tx_hash = contract.functions.addVeterinarianDoctor(veterinarian_address, veterinarian_id).transact({'from': selected_account, 'gas': 1000000})
    # View Receipt
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

################################################
# Add Dog Breeder
################################################

st.markdown("## Add Dog Breeder")
st.markdown('##### Broker adds Dog Breeder')
breeder_address = st.text_input("Breeder Address")
breeder_id = st.text_input("Dog Breeder ID")

# Add breeder button
if st.button("Add Dog Breeder"):
    tx_hash = contract.functions.addDogBreeder(breeder_address, breeder_id).transact({'from': selected_account, 'gas': 1000000})
    # View Receipt
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

################################################
# Register Puppy
################################################

st.markdown("## Register New Puppy")
st.markdown('##### Dog Breeder adds Puppy')
puppy_id = st.text_input("Enter the puppy ID")
dame_id = st.text_input("Enter the dame ID")
sire_id = st.text_input("Enter the dog sire ID")
litter_id = st.text_input("Enter the dog litter ID")
litter_size = st.number_input("Enter the litter size", value=0, step=1 )
dog_breed = st.text_input("Enter the dog breed")
birth_date= st.text_input("Enter the dog birth date")

if st.button("Register New Puppy"):
    tx_hash = contract.functions.addDog(puppy_id,dame_id,sire_id,litter_id,litter_size,dog_breed,birth_date).transact({'from': selected_account, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

################################################
# Add Puppy Health Report
################################################

st.markdown("## Add Puppy Health Report")
st.markdown('##### Doctor adds Health Report')
puppy_id = st.text_input("Puppy ID")
vet_address = st.text_input("Vet  Address")
vet_id = st.text_input("Vet  ID")
remarks = st.text_input("Add Remarks")

# Add breeder button
if st.button("Add Health Report"):
    tx_hash = contract.functions.addPuppyReport(puppy_id, vet_address, vet_id, remarks).transact({'from': selected_account, 'gas': 1000000})
    # View Receipt
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)

################################################
# Add Dog Owner
################################################

st.markdown("## Assign Dog Owner")
st.markdown('##### Broker adds New Dog Owner')
owner_address = st.text_input("Owner Address")
puppy_id = st.text_input("PuppyID")

# Add breeder button
if st.button("Add Dog Owner"):
    tx_hash = contract.functions.addPuppyOwner(owner_address, puppy_id).transact({'from': selected_account, 'gas': 1000000})
    # View Receipt
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write(receipt)
