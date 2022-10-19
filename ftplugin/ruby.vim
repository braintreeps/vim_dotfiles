if filereadable(expand(".rubocop.yml"))
  let g:ale_linters['ruby'] = ['rubocop']
  let g:ale_fixers['ruby'] = ['rubocop']
endif
