rule '.pdf' => '.dot' do |t|
  sh 'dot', '-T', 'pdf', '-o', t.name, t.source
end

task diagrams: Dir['doc/*.dot'].map { |f| f.gsub(/dot$/, 'pdf') }
