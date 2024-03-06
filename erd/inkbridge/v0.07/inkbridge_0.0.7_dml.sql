# 포인트 정책 유형 기본 값
INSERT INTO point_policy_type
VALUES (1, 'REGISTER'),
       (2, 'REVIEW'),
       (3, 'PHOTO_REVIEW');

# 포인트 정책 기본 값
INSERT INTO point_policy (accumulate_point, created_at, point_policy_type_id)
VALUES (5000, '2024-02-22', 1),
       (200, '2024-02-22', 2),
       (500, '2024-02-22', 3);

# 배송비 정책 기본 값
INSERT INTO delivery_policy (delivery_price, created_at)
VALUES (5000, '2024-02-22', 50000);

# 기본 적립율 정책 기본 값
INSERT INTO accumulation_rate_policy (accumulation_rate, created_at)
VALUES (2, '2024-02-22');

# 멤버 등급 기본 값
INSERT INTO member_grade
VALUES (1, 'STANDARD', 1.0, 0),
       (2, 'ROYAL', 1.0, 100000),
       (3, 'GOLD', 2.0, 200000),
       (4, 'PLATINUM', 3.0, 300000);

# 멤버 권한 기본 값
INSERT INTO member_auth
VALUES (1, 'ROLE_MEMBER'),
       (2, 'ROLE_ADMIN');

# 멤버 상태 기본 값
INSERT INTO member_status
VALUES (1, 'ACTIVE'),
       (2, 'DORMANT'),
       (3, 'CLOSE');

# 쿠폰 상태 - 정상, 삭제, 만료, 대기
INSERT INTO coupon_status
VALUES (1, 'NORMAL'),
       (2, 'DELETE'),
       (3, 'EXPIRATION'),
       (4, 'WAIT');

# 쿠폰 타입 - 1 percent , 2 money
INSERT INTO coupon_type
VALUES (1, 'PERCENT'),
       (2, 'MONEY');

