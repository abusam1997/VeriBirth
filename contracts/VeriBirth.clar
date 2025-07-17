(define-data-var certificate-counter uint u0)

(define-map birth-certificates
  { certificate-id: uint } ;; auto-incremented ID
  {
    child-name: (string-utf8 50),
    dob: uint, ;; date of birth in Unix timestamp
    gender: (string-utf8 6),
    parent: principal,
    hospital: principal,
    record-hash: (string-utf8 100),
    is-verified: bool
  })

(define-map pending-approvals
  { certificate-id: uint }
  { hospital: principal })

(define-public (submit-certificate 
    (child-name (string-utf8 50)) 
    (dob uint)
    (gender (string-utf8 6))
    (hospital principal)
    (record-hash (string-utf8 100))
  )
  (let (
        (current-id (var-get certificate-counter))
      )
    (begin
      ;; Input validation
      (asserts! (and 
        (> (len child-name) u0) 
        (< (len child-name) u50)
      ) (err u401))
      (asserts! (> dob u0) (err u402))
      (asserts! (and 
        (> (len gender) u0)
        (< (len gender) u6)
      ) (err u403))
      (asserts! (and 
        (> (len record-hash) u0)
        (< (len record-hash) u100)
      ) (err u404))
      ;; Hospital validation - ensure it's not the zero address
      (asserts! (not (is-eq hospital 'SP000000000000000000002Q6VF78)) (err u405))
      (map-set birth-certificates
        { certificate-id: current-id }
        {
          child-name: child-name,
          dob: dob,
          gender: gender,
          parent: tx-sender,
          hospital: hospital,
          record-hash: record-hash,
          is-verified: false
        }
      )
      (map-set pending-approvals
        { certificate-id: current-id }
        { hospital: hospital }
      )
      (var-set certificate-counter (+ current-id u1))
      (ok current-id)
    )
  )
)

(define-public (verify-certificate (certificate-id uint))
  (begin
    ;; Input validation
    (asserts! (< certificate-id (var-get certificate-counter)) (err u405))
    (let ((stored-hospital (unwrap! (map-get? pending-approvals { certificate-id: certificate-id }) (err u404))))
      (if (is-eq (get hospital stored-hospital) tx-sender)
        (begin
          (map-set birth-certificates
            { certificate-id: certificate-id }
            (let ((existing (unwrap! (map-get? birth-certificates { certificate-id: certificate-id }) (err u404))))
              (merge existing
                {
                  is-verified: true
                }
              )
            )
          )
          (map-delete pending-approvals { certificate-id: certificate-id })
          (ok true)
        )
        (err u403) ;; Unauthorized
      )
    )
  )
)

(define-read-only (get-certificate (certificate-id uint))
  (map-get? birth-certificates { certificate-id: certificate-id })
)

(define-read-only (get-latest-id)
  (var-get certificate-counter)
)
