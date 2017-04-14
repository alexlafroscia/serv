use Mix.Config
alias Dogma.Rule

config :dogma,

  # Select a set of rules as a base
  rule_set: Dogma.RuleSet.All,

  # Pick paths not to lint
  exclude: [
    ~r(\Aapps/file_manager/config/),
    ~r(\Aapps/web_server/config/),
    ~r(\Aconfig/),
    ~r(\Alib/vendor/),
  ],

  # Override an existing rule configuration
  override: [
    %Rule.CommentFormat{ enabled: false },
    %Rule.LineLength{ max_length: 120 }
  ]
