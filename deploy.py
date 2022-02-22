import json
from solcx import compile_standard, install_solc
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

# Compile solidity
install_solc("0.6.12")
compile_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.12",
)


with open("complied_code.json", "w") as file:
    json.dump(compile_sol, file)


# get bytecode
bytecode = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = json.loads(
    compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["metadata"]
)["output"]["abi"]

# print(abi)

# connect to ganache chain
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:8545"))
chain_id = 1337
my_address = os.getenv("MY_GANACHE_ADDRESS")
private_key = os.getenv("PRIVATE_KEY")

# create a contract
print("Deploying contract")
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
print("Deploying complete")

# Get latest nounce
nonce = w3.eth.getTransactionCount(my_address)

print("Creating txn")
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)
print("Signing txn")
signed_transaction = w3.eth.account.sign_transaction(
    transaction, private_key=private_key
)
tx_hash = w3.eth.send_raw_transaction(signed_transaction.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
nonce += 1
print("Txn complete")

simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

print("Creating txn")
store_tx = simple_storage.functions.store(143).buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)
print("Signing txn")
signed_store_tx = w3.eth.account.sign_transaction(store_tx, private_key=private_key)
store_tx_hash = w3.eth.send_raw_transaction(signed_store_tx.rawTransaction)
store_tx_recipt = w3.eth.wait_for_transaction_receipt(store_tx_hash)
nonce += 1
print("Txn complete")

print(simple_storage.functions.retrive().call())
