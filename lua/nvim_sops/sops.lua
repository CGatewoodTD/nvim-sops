local debug = require("nvim_sops.utils").debug
local M = {}

M.get_sops_env_vars = function()
  local sopsGeneralEnvVars = {}

  local backend = vim.g.nvim_sops_backend

  local awsProfile = vim.g.nvim_sops_defaults_aws_profile
  local gcpCredentialsPath = vim.g.nvim_sops_defaults_gcp_credentials_path
  local ageKeyFile = vim.g.nvim_sops_defaults_age_key_file
  local pgpFingerprints = vim.g.nvim_sops_defaults_pgp_fingerprints

  if backend == "vault" then
    sopsGeneralEnvVars.VAULT_TOKEN = vim.fn.system('vault token lookup | grep "^id " | grep -o "[^ ]*$')
  end

  if backend == "aws" then
    if awsProfile then
      sopsGeneralEnvVars.AWS_PROFILE = awsProfile
    end
  end

  if backend == "gcp" then
    if gcpCredentialsPath then
      sopsGeneralEnvVars.GOOGLE_APPLICATION_CREDENTIALS = gcpCredentialsPath
    end
  end

  if backend == "age" then
    if ageKeyFile then
      sopsGeneralEnvVars.SOPS_AGE_KEY_FILE = ageKeyFile
    end
  end

  if backend == "pgp" then
    if pgpFingerprints then
      sopsGeneralEnvVars.SOPS_PGP_FP = pgpFingerprints
    end
  end

  for key, value in pairs(sopsGeneralEnvVars) do
    debug('sops option: ' .. key .. ' = ' .. value)
  end

  return sopsGeneralEnvVars
end

return M
