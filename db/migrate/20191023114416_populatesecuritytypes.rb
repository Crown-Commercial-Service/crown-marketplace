class Populatesecuritytypes < ActiveRecord::Migration[5.2]
  def up
    execute %(truncate table fm_security_types;)
    execute %(INSERT INTO fm_security_types (id,title,description,sort_order) VALUES
('82172139-3ade-4cf1-9d62-babf9d8c1fdd','Baseline personnel security standard (BPSS)','generally used as pre-employment checks. Ascertains the
trustworthiness and reliability of a prospective candidate, looking at
Identity, Employment history, Nationality and immigration status, and
Criminal record',1)
,('592c3fdf-d5a2-4283-a965-5a24c4ae507a','Counter terrorist check (CTC)','is carried out if an individual is working in proximity to public figures, or
requires unescorted access to certain military, civil, industrial or
commercial establishments assessed to be at particular risk from
terrorist attack',2)
,('b0b20156-3a2e-48aa-aaa2-3772b6cec0c3','Security check (SC)','determines that a person’s character and personal circumstances are
such that they can be trusted to work in a position which involves longterm, frequent and uncontrolled access to SECRET assets',3)
,('df8527b6-8257-462a-b093-2fbaca370d80','Developed vetting (DV)','in addition to SC, this detailed check is appropriate when an individual
has long term, frequent and uncontrolled access to ‘Top Secret’
information. There is also Enhanced DV',4)
,('e218afcd-0ac7-46e4-8b23-f0e822c662a3','Basic DBS','for any purpose, including employment. The certificate will contain
details of convictions and conditional cautions that are considered to be
unspent',5)
,('671ba66f-9f40-41c4-bfb4-9bafe2574c67','Standard DBS','contains details of both spent and unspent convictions, cautions,
reprimands and warnings that are held on the Police National Computer',6)
,('0fd4ac35-c6d3-41c0-a8be-edce11242b4f','Enhanced DBS','as per the Standard DBS, plus also searches the DBS Barred Lists, inc the
Children’s Barred List',7)
,('b9e6a0de-f698-4490-8372-17d368fc94a7','Disclosure Scotland Basic','a criminal record check, containing unspent criminal convictions',8)
,('756bef4b-dfff-4ba1-bec3-b269b0b8fc9a','Disclosure Scotland Standard','contains information on convictions and cautions, information from Sex
Offenders Register',9)
,('66ca9d31-f02b-4461-b81a-d997b4e606fe','Disclosure Scotland Enhanced','contains information on convictions and cautions, information from Sex
Offenders Register',10)
,('2a569037-9636-4281-916f-dc848a9ec1bb','Protecting Vulnerable Groups (PVG) scheme','contains conviction information, and any other non-conviction
information that the police or other government bodies think is relevant',11)
,('b5c317c3-d3e8-4d83-807b-77e54e4ce53f','AccessNI Basic','contains details of all convictions considered to be unspent',12)
,('37fd85d7-884f-4484-aba6-46b01211410d','AccessNI Standard','contains details of all spent and unspent convictions, informed
warnings, cautions and diversionary youth conferences',13)
,('ec9949b9-0e6e-4b56-9176-e938bb0a1998','AccessNI Enhanced','contains the same information as a standard check and police records
held locally. To work with children and vulnerable adults, the check may
include information held by the Disclosure and Barring Service (DBS)',14);)
  end
end
