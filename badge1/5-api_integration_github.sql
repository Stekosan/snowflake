use garden_plants
use schema flowers

// A user with the CREATE INTEGRATION privilege granted may run this query to create an API integration allowing users to connect to a git provider.
 // For more information, see: https://docs.snowflake.com/en/developer-guide/git/git-setting-up#create-an-api-integration-for-interacting-with-the-repository-api
 
create or replace api integration github_api_integration
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/Stekosan')
    enabled = true
    allowed_authentication_secrets = all
    -- comment='<comment>';