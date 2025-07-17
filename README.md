# VeriBirth Smart Contract

VeriBirth is a Clarity smart contract for secure, decentralized birth certificate issuance and verification on the Stacks blockchain.

## Features

- **Submit Birth Certificate:**  
  Parents can submit birth certificate data, including child name, date of birth, gender, hospital, and a record hash.

- **Hospital Verification:**  
  Only the designated hospital can verify submitted certificates.

- **Certificate Retrieval:**  
  Anyone can read certificate details by ID.

- **Auto-Incremented IDs:**  
  Each certificate is assigned a unique, auto-incremented ID.

## Contract Functions

| Function                | Type         | Description                                                      |
|-------------------------|--------------|------------------------------------------------------------------|
| `submit-certificate`    | Public       | Submit a new birth certificate for approval.                     |
| `verify-certificate`    | Public       | Hospital verifies a pending certificate.                         |
| `get-certificate`       | Read-Only    | Retrieve certificate details by ID.                              |
| `get-latest-id`         | Read-Only    | Get the latest certificate ID (next to be assigned).             |

## Data Structures

- **birth-certificates (map):**  
  Stores certificate data keyed by certificate ID.

- **pending-approvals (map):**  
  Tracks certificates awaiting hospital verification.

- **certificate-counter (variable):**  
  Auto-incremented counter for certificate IDs.

## Usage

1. **Deploy the contract** to your Stacks testnet/mainnet environment.
2. **Call `submit-certificate`** with required details to create a new certificate.
3. **Hospital calls `verify-certificate`** to approve the certificate.
4. **Use `get-certificate`** to view certificate data.

## Error Codes

- `u401` – Invalid child name length
- `u402` – Invalid date of birth
- `u403` – Invalid gender or unauthorized verification
- `u404` – Invalid record hash or certificate not found
- `u405` – Invalid hospital address or certificate ID

## Requirements

- [Clarity](https://docs.stacks.co/docs/clarity-language/)
- Stacks blockchain environment
