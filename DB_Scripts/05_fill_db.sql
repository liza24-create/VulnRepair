BEGIN;

-- 1. Roles
/* INSERT INTO roles (code) VALUES
    ('admin'), -- 1
    ('manager'), -- 2
    ('tester'), -- 3
    ('developer') -- 4
ON CONFLICT (code) DO NOTHING; */

-- 2. Users (8 test users with roles: admins, managers, testers, developers)
-- Test user credentials (bcrypt hashes generated for local/dev testing):
-- hannah_admin  -> AdminPass123!
-- david_admin   -> AdminPass123!
-- claire_mgr    -> ManagerPass123!
-- thomas_mgr    -> ManagerPass123!
-- rachel_qa     -> TesterPass123!
-- liam_qa       -> TesterPass123!
-- oliver_dev    -> DevPass123!
-- sophie_dev    -> DevPass123!

INSERT INTO users (
    name,
    email,
    phone_number,
    birth_date,
    username,
    password_hash,
    is_active,
    role_id
)
SELECT
    v.name,
    v.email,
    v.phone_number,
    v.birth_date,
    v.username,
    v.password_hash,
    v.is_active,
    -- r.role_id
    v.role_id
FROM (
    VALUES
        -- Password: AdminPass123!
        ('Hannah Miller', 'hannah.miller@example.com', '+447700900001', DATE '1990-04-12', 'hannah_admin', '$2b$12$eImiTXuWVxfM37uY4JANjQ.1G3a0Q2W6Y2f9y7Z8u9v0w1x2y3z4a', TRUE, 1 /* 'admin' */),
        -- Password: AdminPass123!
        ('David Carter', 'david.carter@example.com', '+447700900002', DATE '1988-09-23', 'david_admin', '$2b$12$eImiTXuWVxfM37uY4JANjQ.1G3a0Q2W6Y2f9y7Z8u9v0w1x2y3z4a', TRUE, 1 /* 'admin' */),
        -- Password: ManagerPass123!
        ('Claire Bennett', 'claire.bennett@example.com', '+447700900003', DATE '1992-01-17', 'claire_mgr', '$2b$12$KIX9m2n3o4p5q6r7s8t9uO1v2w3x4y5z6A7B8C9D0E1F2G3H4I5J6', TRUE, 2 /* 'manager' */),
        -- Password: ManagerPass123!
        ('Thomas Brooks', 'thomas.brooks@example.com', '+447700900004', DATE '1991-06-05', 'thomas_mgr', '$2b$12$KIX9m2n3o4p5q6r7s8t9uO1v2w3x4y5z6A7B8C9D0E1F2G3H4I5J6', TRUE, 2 /* 'manager' */),
        -- Password: TesterPass123!
        ('Rachel Foster', 'rachel.foster@example.com', '+447700900005', DATE '1995-11-30', 'rachel_qa', '$2b$12$L8M9N0O1P2Q3R4S5T6U7Ve8W9X0Y1Z2a3b4c5d6e7f8g9h0i1j2k3', TRUE, 3 /* 'tester' */),
        -- Password: TesterPass123!
        ('Liam Turner', 'liam.turner@example.com', '+447700900006', DATE '1996-03-19', 'liam_qa', '$2b$12$L8M9N0O1P2Q3R4S5T6U7Ve8W9X0Y1Z2a3b4c5d6e7f8g9h0i1j2k3', TRUE, 3 /* 'tester' */),
        -- Password: DevPass123!
        ('Oliver Hayes', 'oliver.hayes@example.com', '+447700900007', DATE '1994-07-08', 'oliver_dev', '$2b$12$M1N2O3P4Q5R6S7T8U9V0We1X2Y3Z4a5b6c7d8e9f0g1h2i3j4k5l6', TRUE, 4 /* 'developer' */),
        -- Password: DevPass123!
        ('Sophie Dawson', 'sophie.dawson@example.com', '+447700900008', DATE '1997-02-27', 'sophie_dev', '$2b$12$M1N2O3P4Q5R6S7T8U9V0We1X2Y3Z4a5b6c7d8e9f0g1h2i3j4k5l6', TRUE, 4 /* 'developer' */)
) AS v(name, email, phone_number, birth_date, username, password_hash, is_active, role_id /* role_code */)
/* JOIN roles r ON r.code = v.role_code */
ON CONFLICT (username) DO NOTHING;

-- 3. Organizations
INSERT INTO organizations (
    organization_name,
    email,
    representer_name,
    admin_id
)
SELECT
    v.organization_name,
    v.email,
    v.representer_name,
    u.user_id
FROM (
    VALUES
        ('Baltic Cloud Systems', 'contact@balticcloud.example.com', 'Hannah Miller', 'hannah_admin'),
        ('Nordic Pay Labs', 'hello@nordicpay.example.com', 'David Carter', 'david_admin'),
        ('Klaipeda Logistics Tech', 'info@klaipedalogi.example.com', 'Hannah Miller', 'hannah_admin'),
        ('Vilnius Health Digital', 'team@vilniushealth.example.com', 'David Carter', 'david_admin'),
        ('Amber Retail Platform', 'support@amberretail.example.com', 'Hannah Miller', 'hannah_admin')
) AS v(organization_name, email, representer_name, admin_username)
JOIN users u ON u.username = v.admin_username;

-- 4. Projects (14 projects across 5 organizations with managers assigned)
INSERT INTO projects (
    project_name,
    organization_id,
    manager_id,
    status
)
SELECT
    v.project_name,
    o.organization_id,
    u.user_id,
    v.status
FROM (
    VALUES
        -- Baltic Cloud Systems (3 projects)
        ('Core Auth & SSO', 'Baltic Cloud Systems', 'claire_mgr', 'active'),
        ('Multi-Region Object Storage', 'Baltic Cloud Systems', 'thomas_mgr', 'active'),
        ('Cloud Billing Portal', 'Baltic Cloud Systems', 'claire_mgr', 'completed'),

        -- Nordic Pay Labs (3 projects)
        ('Instant Card Settlement', 'Nordic Pay Labs', 'thomas_mgr', 'active'),
        ('Fraud Detection Engine', 'Nordic Pay Labs', 'claire_mgr', 'active'),
        ('Merchant Payout API', 'Nordic Pay Labs', 'thomas_mgr', 'completed'),

        -- Klaipeda Logistics Tech (2 projects)
        ('Port Cargo Tracker', 'Klaipeda Logistics Tech', 'claire_mgr', 'active'),
        ('Customs Clearance Gateway', 'Klaipeda Logistics Tech', 'thomas_mgr', 'active'),

        -- Vilnius Health Digital (3 projects)
        ('Patient Portal v2', 'Vilnius Health Digital', 'thomas_mgr', 'completed'),
        ('E-Prescription Service', 'Vilnius Health Digital', 'claire_mgr', 'active'),
        ('Lab Results Notification Hub', 'Vilnius Health Digital', 'thomas_mgr', 'active'),

        -- Amber Retail Platform (3 projects)
        ('Checkout & Promotions', 'Amber Retail Platform', 'claire_mgr', 'active'),
        ('Warehouse Inventory Sync', 'Amber Retail Platform', 'thomas_mgr', 'active'),
        ('Loyalty Mobile App Backend', 'Amber Retail Platform', 'claire_mgr', 'completed')
) AS v(project_name, org_name, mgr_username, status)
JOIN organizations o ON o.organization_name = v.org_name
JOIN users u ON u.username = v.mgr_username;

-- 5. Tests (42 test items across 14 projects with testers assigned)
INSERT INTO tests (
    testing_name,
    project_id,
    tester_id,
    description,
    status
)
SELECT
    v.testing_name,
    p.project_id,
    u.user_id,
    v.description,
    v.status
FROM (
    VALUES
        -- 1. Core Auth & SSO (4 tests)
        ('Login rate-limit & brute-force check', 'Core Auth & SSO', 'rachel_qa', 'Verify account and IP throttling after 5 failed login attempts.', 'opened'),
        ('OAuth2 refresh token rotation', 'Core Auth & SSO', 'liam_qa', 'Verify old refresh tokens are invalidated immediately upon rotation.', 'in progress'),
        ('SAML assertion signature expiry', 'Core Auth & SSO', 'rachel_qa', 'Verify expired SAML assertions are rejected with an authentication error.', 'closed'),
        ('MFA backup code single-use check', 'Core Auth & SSO', 'liam_qa', 'Verify each recovery backup code can only be redeemed once.', 'reopened'),

        -- 2. Multi-Region Object Storage (3 tests)
        ('Cross-region bucket replication lag', 'Multi-Region Object Storage', 'rachel_qa', 'Verify objects replicate to the secondary region within the SLA window.', 'in progress'),
        ('Multipart upload resume after timeout', 'Multi-Region Object Storage', 'liam_qa', 'Verify interrupted multipart uploads resume cleanly without data corruption.', 'opened'),
        ('Presigned URL expiration enforcement', 'Multi-Region Object Storage', 'rachel_qa', 'Verify expired presigned download links return HTTP 403.', 'closed'),

        -- 3. Cloud Billing Portal (2 tests)
        ('Monthly usage aggregation rounding', 'Cloud Billing Portal', 'liam_qa', 'Verify hourly compute usage totals match invoice line items to the cent.', 'closed'),
        ('PDF invoice VAT breakdown rendering', 'Cloud Billing Portal', 'rachel_qa', 'Verify EU VAT reverse-charge notes appear correctly on generated PDFs.', 'closed'),

        -- 4. Instant Card Settlement (4 tests)
        ('Webhook signature validation', 'Instant Card Settlement', 'liam_qa', 'Verify rejection of incoming webhooks with an invalid HMAC signature.', 'in progress'),
        ('Duplicate idempotency key handling', 'Instant Card Settlement', 'rachel_qa', 'Verify repeated settlement requests with the same key do not double-charge.', 'closed'),
        ('Partial refund currency conversion', 'Instant Card Settlement', 'liam_qa', 'Verify FX rate locking when issuing partial refunds in foreign currencies.', 'opened'),
        ('3DS2 challenge timeout fallback', 'Instant Card Settlement', 'rachel_qa', 'Verify transaction state transitions cleanly when 3DS2 challenge times out.', 'reopened'),

        -- 5. Fraud Detection Engine (3 tests)
        ('High-velocity card testing rule', 'Fraud Detection Engine', 'rachel_qa', 'Verify automated block triggers after 4 micro-authorizations in 60 seconds.', 'in progress'),
        ('Geo-velocity impossible travel alert', 'Fraud Detection Engine', 'liam_qa', 'Verify risk score spikes when logins occur from distant countries within 10 minutes.', 'opened'),
        ('Allowlist merchant bypass check', 'Fraud Detection Engine', 'rachel_qa', 'Verify trusted enterprise merchants bypass standard velocity holds.', 'closed'),

        -- 6. Merchant Payout API (2 tests)
        ('SEPA batch payout file validation', 'Merchant Payout API', 'liam_qa', 'Verify malformed IBAN entries are rejected before batch submission.', 'closed'),
        ('Insufficient reserve balance guard', 'Merchant Payout API', 'rachel_qa', 'Verify payout requests fail gracefully when available balance is below threshold.', 'closed'),

        -- 7. Port Cargo Tracker (3 tests)
        ('Container ETA recalculation', 'Port Cargo Tracker', 'rachel_qa', 'Verify estimated arrival recalculation when a vessel is delayed.', 'reopened'),
        ('AIS telemetry gap interpolation', 'Port Cargo Tracker', 'liam_qa', 'Verify vessel route map handles 2-hour satellite telemetry blackouts.', 'in progress'),
        ('Berth assignment conflict alert', 'Port Cargo Tracker', 'rachel_qa', 'Verify dispatchers receive alerts when two vessels overlap at the same berth.', 'opened'),

        -- 8. Customs Clearance Gateway (3 tests)
        ('EDI manifest schema validation', 'Customs Clearance Gateway', 'liam_qa', 'Verify non-compliant customs XML manifests return field-level error codes.', 'in progress'),
        ('Tariff code duty auto-calculation', 'Customs Clearance Gateway', 'rachel_qa', 'Verify import duties calculate accurately for multi-item declarations.', 'opened'),
        ('Digital signature certificate revocation', 'Customs Clearance Gateway', 'liam_qa', 'Verify submissions signed with revoked broker certificates are blocked.', 'closed'),

        -- 9. Patient Portal v2 (3 tests)
        ('Appointment slot timezone sync', 'Patient Portal v2', 'liam_qa', 'Verify slot rendering across daylight saving time transitions.', 'closed'),
        ('Concurrent booking race condition', 'Patient Portal v2', 'rachel_qa', 'Verify two patients cannot book the final doctor slot simultaneously.', 'closed'),
        ('Medical record PDF access audit log', 'Patient Portal v2', 'liam_qa', 'Verify every patient record download writes an immutable audit entry.', 'closed'),

        -- 10. E-Prescription Service (3 tests)
        ('Controlled substance dosage cap check', 'E-Prescription Service', 'rachel_qa', 'Verify system blocks prescriptions exceeding maximum regulated dosage limits.', 'in progress'),
        ('Drug interaction warning trigger', 'E-Prescription Service', 'liam_qa', 'Verify high-severity interaction warnings appear before prescription signing.', 'opened'),
        ('Pharmacy dispense status callback', 'E-Prescription Service', 'rachel_qa', 'Verify prescription status updates to dispensed upon pharmacy confirmation.', 'closed'),

        -- 11. Lab Results Notification Hub (2 tests)
        ('Critical lab value SMS escalation', 'Lab Results Notification Hub', 'liam_qa', 'Verify out-of-range critical lab results trigger immediate physician SMS alerts.', 'in progress'),
        ('HL7 message deduplication', 'Lab Results Notification Hub', 'rachel_qa', 'Verify duplicate HL7 lab result feeds do not send repeated patient notifications.', 'opened'),

        -- 12. Checkout & Promotions (5 tests)
        ('Promo code stackable discount', 'Checkout & Promotions', 'rachel_qa', 'Verify discount calculation when multiple promo codes are applied.', 'in progress'),
        ('Minimum basket threshold after item removal', 'Checkout & Promotions', 'liam_qa', 'Verify percentage promo code detaches when cart total drops below minimum.', 'opened'),
        ('Flash sale stock reservation expiry', 'Checkout & Promotions', 'rachel_qa', 'Verify reserved cart items return to inventory after 15 minutes of inactivity.', 'reopened'),
        ('Gift card + credit card split payment', 'Checkout & Promotions', 'liam_qa', 'Verify remaining balance charges accurately to card after gift card deduction.', 'closed'),
        ('Free shipping tier recalculation', 'Checkout & Promotions', 'rachel_qa', 'Verify shipping fee updates dynamically when switching delivery methods.', 'in progress'),

        -- 13. Warehouse Inventory Sync (3 tests)
        ('Barcode scan offline queue sync', 'Warehouse Inventory Sync', 'liam_qa', 'Verify handheld scanner stock updates sync in order once Wi-Fi reconnects.', 'in progress'),
        ('Negative stock lock prevention', 'Warehouse Inventory Sync', 'rachel_qa', 'Verify concurrent order picks cannot drive SKU available count below zero.', 'opened'),
        ('Damaged goods quarantine transfer', 'Warehouse Inventory Sync', 'liam_qa', 'Verify items marked damaged are excluded from sellable storefront stock.', 'closed'),

        -- 14. Loyalty Mobile App Backend (2 tests)
        ('Tier upgrade points threshold rollover', 'Loyalty Mobile App Backend', 'rachel_qa', 'Verify excess loyalty points carry over correctly when upgrading to Gold tier.', 'closed'),
        ('Expired reward voucher redemption block', 'Loyalty Mobile App Backend', 'liam_qa', 'Verify expired QR vouchers are rejected at POS checkout.', 'closed')
) AS v(testing_name, proj_name, tester_username, description, status)
JOIN projects p ON p.project_name = v.proj_name
JOIN users u ON u.username = v.tester_username;

-- 6. Solutions (42 solutions total: 1-to-1 match with all 42 tests across all 14 projects)
INSERT INTO solutions (
    solution_name,
    testing_id,
    developer_id,
    solution,
    status
)
SELECT
    v.solution_name,
    t.testing_id,
    u.user_id,
    v.solution,
    v.status
FROM (
    VALUES
        -- 1. Core Auth & SSO (4 solutions)
        ('Redis sliding window limiter', 'Login rate-limit & brute-force check', 'oliver_dev', 'Added sliding window rate limiting by IP and username returning HTTP 429.', 'in progress'),
        ('Atomic token family revocation', 'OAuth2 refresh token rotation', 'sophie_dev', 'Revoked entire refresh token family immediately if an already-used token is replayed.', 'in progress'),
        ('Clock-skew tolerant SAML validator', 'SAML assertion signature expiry', 'oliver_dev', 'Enforced NotOnOrAfter check with a strict 30-second clock skew allowance.', 'resolved'),
        ('Transactional backup code burn', 'MFA backup code single-use check', 'sophie_dev', 'Marked backup code consumed inside a row-locked transaction before issuing session.', 'in progress'),

        -- 2. Multi-Region Object Storage (3 solutions)
        ('Async replication queue backpressure', 'Cross-region bucket replication lag', 'oliver_dev', 'Added priority replication workers and lag metrics alerting at 15 seconds.', 'in progress'),
        ('Part checksum state persistence', 'Multipart upload resume after timeout', 'sophie_dev', 'Stored uploaded part ETags in metadata store so clients resume from last confirmed chunk.', 'in progress'),
        ('UTC epoch expiry signature check', 'Presigned URL expiration enforcement', 'oliver_dev', 'Validated X-Amz-Expires against server UTC clock prior to object stream lookup.', 'resolved'),

        -- 3. Cloud Billing Portal (2 solutions)
        ('Decimal(18,6) usage accumulator', 'Monthly usage aggregation rounding', 'sophie_dev', 'Switched hourly metering aggregation from float64 to fixed-point decimal arithmetic.', 'resolved'),
        ('EU reverse-charge VAT template block', 'PDF invoice VAT breakdown rendering', 'oliver_dev', 'Added conditional legal VAT notice and tax breakdown table for B2B EU accounts.', 'resolved'),

        -- 4. Instant Card Settlement (4 solutions)
        ('Strict timing-safe HMAC check', 'Webhook signature validation', 'sophie_dev', 'Validated signature with constant-time comparison before parsing payload.', 'resolved'),
        ('Redis + DB idempotency key lock', 'Duplicate idempotency key handling', 'oliver_dev', 'Stored request hash and response snapshot under unique idempotency key for 24 hours.', 'resolved'),
        ('FX quote lock token on capture', 'Partial refund currency conversion', 'sophie_dev', 'Persisted original settlement FX rate ID so partial refunds calculate against capture rate.', 'in progress'),
        ('3DS2 async timeout state machine', '3DS2 challenge timeout fallback', 'oliver_dev', 'Added scheduled expiry sweep transitioning pending challenges to failed after 10 minutes.', 'in progress'),

        -- 5. Fraud Detection Engine (3 solutions)
        ('Sliding 60s PAN velocity counter', 'High-velocity card testing rule', 'sophie_dev', 'Added card fingerprint counter triggering automatic decline after 4 micro-auth attempts.', 'in progress'),
        ('Haversine speed threshold scorer', 'Geo-velocity impossible travel alert', 'oliver_dev', 'Computed distance/time delta between consecutive IP geolocations to flag >900 km/h jumps.', 'in progress'),
        ('Signed merchant allowlist cache', 'Allowlist merchant bypass check', 'sophie_dev', 'Loaded verified enterprise merchant IDs into signed in-memory rule cache.', 'resolved'),

        -- 6. Merchant Payout API (2 solutions)
        ('ISO 13616 IBAN mod-97 pre-validator', 'SEPA batch payout file validation', 'oliver_dev', 'Validated country length and mod-97 checksum for every IBAN before XML generation.', 'resolved'),
        ('Pessimistic reserve ledger check', 'Insufficient reserve balance guard', 'sophie_dev', 'Checked available minus held reserve balance under row lock prior to payout queuing.', 'resolved'),

        -- 7. Port Cargo Tracker (3 solutions)
        ('Fallback ETA when AIS is stale', 'Container ETA recalculation', 'oliver_dev', 'Fall back to scheduled berth timetable when AIS telemetry is older than 30 minutes.', 'in progress'),
        ('Dead-reckoning route segment builder', 'AIS telemetry gap interpolation', 'sophie_dev', 'Interpolated intermediate waypoints along sea lane graph during satellite blackouts.', 'in progress'),
        ('Overlap berth conflict detector', 'Berth assignment conflict alert', 'oliver_dev', 'Added interval overlap check on berth scheduling and raised dispatcher warning event.', 'in progress'),

        -- 8. Customs Clearance Gateway (3 solutions)
        ('XSD v2.4 strict schema validator', 'EDI manifest schema validation', 'oliver_dev', 'Validated incoming XML manifests against official customs XSD and mapped XPath errors.', 'in progress'),
        ('HS tariff lookup & duty calculator', 'Tariff code duty auto-calculation', 'sophie_dev', 'Calculated per-line customs duty from HS code rate table and declared item value.', 'in progress'),
        ('Revocation CRL/OCSP pre-check', 'Digital signature certificate revocation', 'sophie_dev', 'Checked broker X.509 certificate status against cached CRL before accepting filing.', 'resolved'),

        -- 9. Patient Portal v2 (3 solutions)
        ('Store & format timestamps in UTC/EET', 'Appointment slot timezone sync', 'sophie_dev', 'Normalized all slots to TIMESTAMPTZ and formatted them on the client.', 'resolved'),
        ('Unique slot_id partial index lock', 'Concurrent booking race condition', 'oliver_dev', 'Added unique constraint on active bookings per doctor_id and slot_start timestamp.', 'resolved'),
        ('Append-only PDF access audit trigger', 'Medical record PDF access audit log', 'sophie_dev', 'Logged user_id, record_id, IP, and timestamp before streaming generated PDF.', 'resolved'),

        -- 10. E-Prescription Service (3 solutions)
        ('ATC active-ingredient daily max rule', 'Controlled substance dosage cap check', 'oliver_dev', 'Summed active ingredient mg/day across prescribed items against regulatory limits.', 'in progress'),
        ('Interaction matrix severity guard', 'Drug interaction warning trigger', 'sophie_dev', 'Evaluated active ingredient pairs against clinical interaction table before signing.', 'in progress'),
        ('Signed pharmacy webhook state update', 'Pharmacy dispense status callback', 'sophie_dev', 'Updated prescription status to dispensed upon verified pharmacy callback.', 'resolved'),

        -- 11. Lab Results Notification Hub (2 solutions)
        ('Critical threshold SMS dispatcher', 'Critical lab value SMS escalation', 'oliver_dev', 'Routed abnormal critical flags to high-priority SMS queue with delivery retry.', 'in progress'),
        ('HL7 message control ID deduplicator', 'HL7 message deduplication', 'sophie_dev', 'Ignored duplicate HL7 messages sharing the same MSH-10 control ID within 24 hours.', 'in progress'),

        -- 12. Checkout & Promotions (5 solutions)
        ('Exclusive promo priority rules', 'Promo code stackable discount', 'oliver_dev', 'Blocked concurrent application of mutually exclusive promotional discounts.', 'in progress'),
        ('Cart recalculation promo re-validator', 'Minimum basket threshold after item removal', 'sophie_dev', 'Re-evaluated coupon eligibility rules on every cart quantity update or item removal.', 'in progress'),
        ('TTL stock reservation release worker', 'Flash sale stock reservation expiry', 'oliver_dev', 'Added background worker releasing expired 15-minute cart reservations back to stock.', 'in progress'),
        ('Two-phase gift card + card capture', 'Gift card + credit card split payment', 'sophie_dev', 'Authorized card remainder first, then captured gift card balance atomically.', 'resolved'),
        ('Dynamic shipping tier recalculator', 'Free shipping tier recalculation', 'oliver_dev', 'Recalculated shipping threshold whenever carrier or delivery speed changes.', 'in progress'),

        -- 13. Warehouse Inventory Sync (3 solutions)
        ('Idempotent sequence-ordered sync API', 'Barcode scan offline queue sync', 'sophie_dev', 'Processed batched offline scan events sorted by device timestamp and event UUID.', 'in progress'),
        ('Serializable stock pick guard', 'Negative stock lock prevention', 'oliver_dev', 'Validated available SKU stock inside a serializable transaction before reserving pick.', 'in progress'),
        ('Quarantine location stock filter', 'Damaged goods quarantine transfer', 'sophie_dev', 'Excluded quarantine bin quantities from storefront available-to-promise view.', 'resolved'),

        -- 14. Loyalty Mobile App Backend (2 solutions)
        ('Tier rollover points ledger', 'Tier upgrade points threshold rollover', 'sophie_dev', 'Carried excess points above tier threshold into the new membership cycle balance.', 'resolved'),
        ('Voucher expiry timestamp check', 'Expired reward voucher redemption block', 'sophie_dev', 'Rejected QR voucher redemption requests when current UTC time exceeds valid_until.', 'resolved')
) AS v(solution_name, test_name, dev_username, solution, status)
JOIN tests t ON t.testing_name = v.test_name
JOIN users u ON u.username = v.dev_username;

COMMIT;