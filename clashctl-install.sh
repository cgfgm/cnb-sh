GH_PROXY=https://gh-proxy.org/
curl -fsSL "${GH_PROXY}https://raw.githubusercontent.com/nelvko/clashctl/HEAD/install.sh" | \
  bash -s -- --gh-proxy "$GH_PROXY"