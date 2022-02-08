nnoremap gtj :CocCommand go.tags.add json<CR>
nnoremap gtx :CocCommand go.tags.clear<CR>

inoremap ,e if err != nil{}<Left><CR><CR><Up><Tab>fmt.Println(err)<Down><Down>
