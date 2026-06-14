#!/bin/bash
# Integration test cho FE — gọi API qua curl để verify contract
# Chạy: bash test/integration/test_api_contract.sh

set -e

BASE_URL="https://localhost:44396"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================"
echo "FE API Contract Test"
echo "========================================"

# 1. Login
echo -e "\n[1/4] Testing login..."
RESPONSE=$(curl -sk -X POST "$BASE_URL/api/account/login" \
  -H "Content-Type: application/json" \
  -d '{"userNameOrEmailAddress":"devdatnp","password":"M1nhkh@nh1","rememberMe":true}')

if echo "$RESPONSE" | grep -q '"result":1'; then
  echo -e "${GREEN}✅ Login OK${NC}"
else
  echo -e "${RED}❌ Login FAIL${NC}"
  exit 1
fi

# 2. Get token
echo -e "\n[2/4] Getting OAuth token..."
TOKEN_RESPONSE=$(curl -sk -X POST "$BASE_URL/connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=devdatnp&password=M1nhkh%40nh1&client_id=EnglishApp_App&client_secret=1q2w3e*&scope=EnglishApp%20offline_access")

TOKEN=$(echo "$TOKEN_RESPONSE" | python3 -c "import sys,json;print(json.load(sys.stdin)['access_token'])" 2>/dev/null)

if [ -n "$TOKEN" ]; then
  echo -e "${GREEN}✅ Token OK (${#TOKEN} chars)${NC}"
else
  echo -e "${RED}❌ Token FAIL${NC}"
  exit 1
fi

# 3. Get sentences
echo -e "\n[3/4] Testing GET /api/v1/sentences..."
SENTENCES=$(curl -sk -H "Authorization: Bearer $TOKEN" "$BASE_URL/api/v1/sentences?MaxResultCount=5")
TOTAL=$(echo "$SENTENCES" | python3 -c "import sys,json;print(json.load(sys.stdin)['totalCount'])" 2>/dev/null)

if [ "$TOTAL" -gt 0 ]; then
  echo -e "${GREEN}✅ Sentences OK (totalCount=$TOTAL)${NC}"
else
  echo -e "${RED}❌ Sentences FAIL${NC}"
  exit 1
fi

# 4. Get today learning
echo -e "\n[4/4] Testing GET /api/v1/learning/today..."
TODAY=$(curl -sk -H "Authorization: Bearer $TOKEN" "$BASE_URL/api/v1/learning/today")
TODAY_TOTAL=$(echo "$TODAY" | python3 -c "import sys,json;print(json.load(sys.stdin)['totalSentences'])" 2>/dev/null)

if [ "$TODAY_TOTAL" -eq 5 ]; then
  echo -e "${GREEN}✅ Today learning OK (totalSentences=$TODAY_TOTAL)${NC}"
else
  echo -e "${RED}❌ Today learning FAIL${NC}"
  exit 1
fi

echo ""
echo "========================================"
echo -e "${GREEN}✅ ALL API CONTRACTS PASSED${NC}"
echo "========================================"
