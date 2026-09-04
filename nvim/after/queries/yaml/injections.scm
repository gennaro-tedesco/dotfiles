; Azure Pipelines shell steps ("bash", "inlineScript")
(block_mapping_pair
  key: (flow_node) @_key
  (#any-of? @_key "bash" "inlineScript")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))
