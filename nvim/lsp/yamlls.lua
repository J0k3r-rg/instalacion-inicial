return {
  cmd = { "yaml-language-server", "--stdio" },
  root_markers = { ".git" },
  filetypes = { "yaml", "yaml.docker-compose", "yml" },
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
      },
    },
  },
}
