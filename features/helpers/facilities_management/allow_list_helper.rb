def stub_allow_list
  @allow_list_file = Tempfile.new('allow_list.txt')
  @allow_list_file.write(['email.com', 'example.com', 'test.com'].join("\n"))
  @allow_list_file.close
  allow_any_instance_of(AllowedEmailDomain).to receive(:allow_list_file_path).and_return(@allow_list_file.path)
end

def close_allow_list
  @allow_list_file.unlink
end
