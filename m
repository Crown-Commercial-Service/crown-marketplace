Running RuboCop...
Inspecting 512 files
................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................

512 files inspected, no offenses detected
"Creating FM building database"
"Creating FM UOM table"
"Creating FM UOM values table"
"Creating FM lift table"
"Creating FM static data table"
"add services data to fm_static_table"
"add work_packages data to fm_static_table"
"**** Loading FM Supplier rates cards"
"FM rate cards spreadsheet facilities_management/Direct Award Rate Cards - anonymised1.xlsx imported into database"
"Loading FM Suppliers static"
CCS_DEFAULT_DB_HOST 
dummy supplier data
"Loading NUTS static"
"Loading NUTS static data, Environment: development"
"Finished loading NUTS codes into db marketplace_development"
"Loading FM rates static data"

Randomized with seed 13132
..............................................................................................................................................................................................................................................................................FFFFFFFFFFFFFFFFFFFFFFF..................................................................................................................................................................................................................F......................................FFFFFFFFFF...................................................................FF.......................................................................................................................................FFFFFFFFF........................FF.................................................................................................................................................................................................Capybara starting Puma...
* Version 3.12.1 , codename: Llamas in Pajamas
* Min threads: 0, max threads: 4
* Listening on tcp://127.0.0.1:51348
..FFFF..........................................................................................................FFFFFFFFFFFFFFFFFFF......................................................................................................................................................................................................................................FFFFFFFFFFFFF.........................

Failures:

  1) ManagementConsultancy::Upload create when data for one service is invalid raises ActiveRecord::RecordInvalid exception
     Failure/Error:
       expect do
         described_class.upload!(suppliers)
       end.to raise_error(ActiveRecord::RecordInvalid)

       expected ActiveRecord::RecordInvalid, got #<ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "regional_availabilities" does...DELETE FROM "regional_availabilities"
                           ^
       : DELETE FROM "regional_availabilities"> with backtrace:
         # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
         # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
         # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
         # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
         # ./app/models/management_consultancy/upload.rb:4:in `upload!'
         # ./spec/models/management_consultancy/upload_spec.rb:290:in `block (5 levels) in <top (required)>'
         # ./spec/models/management_consultancy/upload_spec.rb:289:in `block (4 levels) in <top (required)>'
     # ./spec/models/management_consultancy/upload_spec.rb:289:in `block (4 levels) in <top (required)>'

  2) ManagementConsultancy::Upload create when data for one service is invalid does not create any suppliers
     Failure/Error:
       expect do
         ignoring_exception(ActiveRecord::RecordInvalid) do
           described_class.upload!(suppliers)
         end
       end.not_to change(ManagementConsultancy::Supplier, :count)

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # ./spec/models/management_consultancy/upload_spec.rb:295:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   ./spec/models/management_consultancy/upload_spec.rb:295:in `block (4 levels) in <top (required)>'

  3) ManagementConsultancy::Upload create when data for one lot is invalid raises ActiveRecord::RecordInvalid exception
     Failure/Error:
       expect do
         described_class.upload!(suppliers)
       end.to raise_error(ActiveRecord::RecordInvalid)

       expected ActiveRecord::RecordInvalid, got #<ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "regional_availabilities" does...DELETE FROM "regional_availabilities"
                           ^
       : DELETE FROM "regional_availabilities"> with backtrace:
         # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
         # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
         # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
         # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
         # ./app/models/management_consultancy/upload.rb:4:in `upload!'
         # ./spec/models/management_consultancy/upload_spec.rb:261:in `block (5 levels) in <top (required)>'
         # ./spec/models/management_consultancy/upload_spec.rb:260:in `block (4 levels) in <top (required)>'
     # ./spec/models/management_consultancy/upload_spec.rb:260:in `block (4 levels) in <top (required)>'

  4) ManagementConsultancy::Upload create when data for one lot is invalid does not create any suppliers
     Failure/Error:
       expect do
         ignoring_exception(ActiveRecord::RecordInvalid) do
           described_class.upload!(suppliers)
         end
       end.not_to change(ManagementConsultancy::Supplier, :count)

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # ./spec/models/management_consultancy/upload_spec.rb:266:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   ./spec/models/management_consultancy/upload_spec.rb:266:in `block (4 levels) in <top (required)>'

  5) ManagementConsultancy::Upload create when suppliers already exist destroys all existing suppliers
     Failure/Error: let!(:first_supplier) { create(:management_consultancy_supplier) }

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
     # ./spec/models/management_consultancy/upload_spec.rb:176:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  6) ManagementConsultancy::Upload create when suppliers already exist and data for one supplier is invalid leaves existing data intact
     Failure/Error: let!(:first_supplier) { create(:management_consultancy_supplier) }

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
     # ./spec/models/management_consultancy/upload_spec.rb:176:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  7) ManagementConsultancy::Upload create when suppliers already exist and data for one supplier is invalid does not create record of unsuccessful upload
     Failure/Error: let!(:first_supplier) { create(:management_consultancy_supplier) }

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
     # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
     # ./spec/models/management_consultancy/upload_spec.rb:176:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  8) ManagementConsultancy::Upload create when supplier list is empty does not create any suppliers
     Failure/Error:
       expect do
         described_class.upload!(suppliers)
       end.not_to change(ManagementConsultancy::Supplier, :count)

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # ./spec/models/management_consultancy/upload_spec.rb:28:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   ./spec/models/management_consultancy/upload_spec.rb:28:in `block (4 levels) in <top (required)>'

  9) ManagementConsultancy::Upload create when data for one supplier is invalid does not create any suppliers
     Failure/Error:
       expect do
         ignoring_exception(ActiveRecord::RecordInvalid) do
           described_class.upload!(suppliers)
         end
       end.not_to change(ManagementConsultancy::Supplier, :count)

     ActiveRecord::StatementInvalid:
       PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
       LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                 ^
       :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                            pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                            c.collname, col_description(a.attrelid, a.attnum) AS comment
                       FROM pg_attribute a
                       LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                       LEFT JOIN pg_type t ON a.atttypid = t.oid
                       LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                      WHERE a.attrelid = '"suppliers"'::regclass
                        AND a.attnum > 0 AND NOT a.attisdropped
                      ORDER BY a.attnum
     # ./spec/models/management_consultancy/upload_spec.rb:237:in `block (4 levels) in <top (required)>'
     # ------------------
     # --- Caused by: ---
     # PG::UndefinedTable:
     #   ERROR:  relation "suppliers" does not exist
     #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
     #                                             ^
     #   ./spec/models/management_consultancy/upload_spec.rb:237:in `block (4 levels) in <top (required)>'

  10) ManagementConsultancy::Upload create when data for one supplier is invalid raises ActiveRecord::RecordInvalid exception
      Failure/Error:
        expect do
          described_class.upload!(suppliers)
        end.to raise_error(ActiveRecord::RecordInvalid)

        expected ActiveRecord::RecordInvalid, got #<ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "regional_availabilities" does...DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"> with backtrace:
          # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
          # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
          # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
          # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
          # ./app/models/management_consultancy/upload.rb:4:in `upload!'
          # ./spec/models/management_consultancy/upload_spec.rb:232:in `block (5 levels) in <top (required)>'
          # ./spec/models/management_consultancy/upload_spec.rb:231:in `block (4 levels) in <top (required)>'
      # ./spec/models/management_consultancy/upload_spec.rb:231:in `block (4 levels) in <top (required)>'

  11) ManagementConsultancy::Upload create when supplier does not exist assigns attributes to supplier
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:55:in `block (4 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  12) ManagementConsultancy::Upload create when supplier does not exist assigns contact-related attributes to supplier
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:62:in `block (4 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  13) ManagementConsultancy::Upload create when supplier does not exist creates record of successful upload
      Failure/Error:
        expect do
          described_class.upload!(suppliers)
        end.to change(ManagementConsultancy::Upload, :count).by(1)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "uploads" does not exist
        LINE 8:                WHERE a.attrelid = '"uploads"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"uploads"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # ./spec/models/management_consultancy/upload_spec.rb:36:in `block (4 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "uploads" does not exist
      #   LINE 8:                WHERE a.attrelid = '"uploads"'::regclass
      #                                             ^
      #   ./spec/models/management_consultancy/upload_spec.rb:36:in `block (4 levels) in <top (required)>'

  14) ManagementConsultancy::Upload create when supplier does not exist assigns ID to supplier
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:48:in `block (4 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  15) ManagementConsultancy::Upload create when supplier does not exist creates supplier
      Failure/Error:
        expect do
          described_class.upload!(suppliers)
        end.to change(ManagementConsultancy::Supplier, :count).by(1)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # ./spec/models/management_consultancy/upload_spec.rb:42:in `block (4 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   ./spec/models/management_consultancy/upload_spec.rb:42:in `block (4 levels) in <top (required)>'

  16) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to second service offering
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:158:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  17) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to third service offering
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:166:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  18) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to first service offering
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:150:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  19) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services creates service offerings associated with supplier
      Failure/Error:
        expect do
          described_class.upload!(suppliers)
        end.to change(ManagementConsultancy::ServiceOffering, :count).by(3)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # ./spec/models/management_consultancy/upload_spec.rb:144:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   ./spec/models/management_consultancy/upload_spec.rb:144:in `block (5 levels) in <top (required)>'

  20) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions creates regional availabilities associated with supplier
      Failure/Error:
        expect do
          described_class.upload!(suppliers)
        end.to change(ManagementConsultancy::RegionalAvailability, :count).by(3)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # ./spec/models/management_consultancy/upload_spec.rb:90:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   ./spec/models/management_consultancy/upload_spec.rb:90:in `block (5 levels) in <top (required)>'

  21) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to third regional availability
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:114:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  22) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to second regional availability
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:105:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  23) ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to first regional availability
      Failure/Error: RegionalAvailability.delete_all

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 1: DELETE FROM "regional_availabilities"
                            ^
        : DELETE FROM "regional_availabilities"
      # ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'
      # ./app/models/management_consultancy/upload.rb:5:in `block in upload!'
      # ./app/models/management_consultancy/upload.rb:18:in `block in all_or_none'
      # ./app/models/management_consultancy/upload.rb:17:in `all_or_none'
      # ./app/models/management_consultancy/upload.rb:4:in `upload!'
      # ./spec/models/management_consultancy/upload_spec.rb:96:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 1: DELETE FROM "regional_availabilities"
      #                       ^
      #   ./app/models/management_consultancy/supplier.rb:44:in `delete_all_with_dependents'

  24) ManagementConsultancy::SupplierSpreadsheetCreator.build returns an Axlsx::Package
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/services/management_consultancy/supplier_spreadsheet_creator_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/services/management_consultancy/supplier_spreadsheet_creator_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/services/management_consultancy/supplier_spreadsheet_creator_spec.rb:15:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  25) ManagementConsultancy::RegionalAvailability is valid even if availability exists for same region_code & supplier, but different lot_number
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:44:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  26) ManagementConsultancy::RegionalAvailability 
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:6:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  27) ManagementConsultancy::RegionalAvailability is not valid if region_code is blank
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:66:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  28) ManagementConsultancy::RegionalAvailability is not valid if region_code is not in list of all region codes
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:71:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  29) ManagementConsultancy::RegionalAvailability is valid even if availability exists for same lot_number & supplier, but different region_code
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:55:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  30) ManagementConsultancy::RegionalAvailability is not valid if lot_number is blank
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:9:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  31) ManagementConsultancy::RegionalAvailability is valid even if availability exists for same lot_number & region_code, but different supplier
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:33:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  32) ManagementConsultancy::RegionalAvailability can be associated with one management consultancy supplier
      Failure/Error: supplier = build(:management_consultancy_supplier)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:77:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  33) ManagementConsultancy::RegionalAvailability is not valid if availability exists for same lot_number, region_code & supplier
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:20:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  34) ManagementConsultancy::RegionalAvailability is not valid if lot_number is not in list of all lot numbers
      Failure/Error: subject(:regional_availability) { build(:management_consultancy_regional_availability) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "regional_availabilities" does not exist
        LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"regional_availabilities"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/regional_availability_spec.rb:14:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "regional_availabilities" does not exist
      #   LINE 8:                WHERE a.attrelid = '"regional_availabilities"...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  35) management_consultancy/suppliers/_supplier.html.erb displays the supplier name
      Failure/Error:
        create(
          :management_consultancy_supplier,
          contact_name: contact_name,
          contact_email: contact_email,
          telephone_number: telephone_number
        )

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:11:in `block (2 levels) in <top (required)>'
      # ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:21:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  36) management_consultancy/suppliers/_supplier.html.erb when the supplier is an SME displays the SME label
      Failure/Error:
        create(
          :management_consultancy_supplier,
          contact_name: contact_name,
          contact_email: contact_email,
          telephone_number: telephone_number
        )

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:11:in `block (2 levels) in <top (required)>'
      # ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:21:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  37) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 assigns lot to the correct lot
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  38) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 renders the index template
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  39) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 assigns suppliers available in lot & regions, with services
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  40) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 assigns suppliers available in lot & regions, with services
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  41) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 renders the index template
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  42) ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 assigns lot to the correct lot
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  43) ManagementConsultancy::SuppliersController GET download renders the download template
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  44) ManagementConsultancy::SuppliersController GET show with no lot number set renders the show template
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  45) ManagementConsultancy::SuppliersController GET show when the lot answer is MCF2 lot1 renders the show template
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:13:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  46) ManagementConsultancy::UploadsController POST create when the app has upload privileges when model validation error occurs responds with 422 Unprocessable Entity
      Failure/Error: let(:supplier) { build(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/uploads_controller_spec.rb:38:in `block (5 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/uploads_controller_spec.rb:41:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  47) ManagementConsultancy::UploadsController POST create when the app has upload privileges when model validation error occurs responds with JSON in body with details of the error
      Failure/Error: let(:supplier) { build(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/controllers/management_consultancy/uploads_controller_spec.rb:38:in `block (5 levels) in <top (required)>'
      # ./spec/controllers/management_consultancy/uploads_controller_spec.rb:41:in `block (5 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  48) Management consultancy Buyer wants to buy complex & transformation services (MCF2 Lot 3)
      Failure/Error: supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/support/stub_auth.rb:59:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  49) Management consultancy Buyer wants to buy procurement, supply chain and commercial services (MCF2 Lot 2)
      Failure/Error: supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/support/stub_auth.rb:59:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  50) Management consultancy Buyer wants to buy strategic services (MCF2 Lot 4)
      Failure/Error: supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/support/stub_auth.rb:59:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  51) Management consultancy Buyer wants to buy business consultancy services (MCF2 Lot 1)
      Failure/Error: supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:5:in `block (2 levels) in <top (required)>'
      # ./spec/support/stub_auth.rb:59:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  52) ManagementConsultancy::Supplier is not valid if name is blank
      Failure/Error: subject(:supplier) { build(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:9:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  53) ManagementConsultancy::Supplier 
      Failure/Error: subject(:supplier) { build(:management_consultancy_supplier) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:6:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  54) ManagementConsultancy::Supplier.delete_all_with_dependents deletes all service offerings
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:205:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:209:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  55) ManagementConsultancy::Supplier.delete_all_with_dependents deletes all regional availabilities
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:205:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:209:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  56) ManagementConsultancy::Supplier.delete_all_with_dependents deletes all suppliers
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:205:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:209:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  57) ManagementConsultancy::Supplier.offering_services_in_regions when expenses are not paid excludes suppliers who require expenses
      Failure/Error: create(:management_consultancy_supplier, name: 'Supplier 1')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:72:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:85:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  58) ManagementConsultancy::Supplier.offering_services_in_regions when expenses are paid returns suppliers with availability in lot and regions
      Failure/Error: create(:management_consultancy_supplier, name: 'Supplier 1')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:72:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:85:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  59) ManagementConsultancy::Supplier.offering_services returns suppliers with availability in lot 1
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:41:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:45:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  60) ManagementConsultancy::Supplier.offering_services only returns suppliers that offer all services
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:41:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:45:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  61) ManagementConsultancy::Supplier.offering_services ignores services when there is a lot mismatch
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:41:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:45:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  62) ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF lot 2
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:14:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:18:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  63) ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF2 lot 3
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:14:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:18:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  64) ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF 2 lot 2
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:14:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:18:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  65) ManagementConsultancy::Supplier.supplying_regions returns suppliers offering services in lot and regions
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:164:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:169:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  66) ManagementConsultancy::Supplier.supplying_regions only includes suppliers offering services in all specified regions
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:164:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:169:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  67) ManagementConsultancy::Supplier.supplying_regions returns multiple matching suppliers
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:164:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:169:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  68) ManagementConsultancy::Supplier.supplying_regions does not include suppliers offering services in a different lot
      Failure/Error: let(:supplier1) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:164:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:169:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  69) ManagementConsultancy::Supplier#services_in_lot returns services in lot 2
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:133:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:140:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  70) ManagementConsultancy::Supplier#services_in_lot returns services in lot 1
      Failure/Error: let(:supplier) { create(:management_consultancy_supplier, name: 'Supplier 1') }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/create.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/supplier_spec.rb:133:in `block (3 levels) in <top (required)>'
      # ./spec/models/management_consultancy/supplier_spec.rb:140:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  71) ManagementConsultancy::ServiceOffering is not valid if offering exists for same lot_number, service_code & supplier
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:20:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  72) ManagementConsultancy::ServiceOffering is valid even if offering exists for same lot_number & service_code, but different supplier
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:33:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  73) ManagementConsultancy::ServiceOffering is valid even if offering exists for same service_code & supplier, but different lot_number
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:44:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  74) ManagementConsultancy::ServiceOffering can be associated with one management consultancy supplier
      Failure/Error: supplier = build(:management_consultancy_supplier)

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "suppliers" does not exist
        LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"suppliers"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:77:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "suppliers" does not exist
      #   LINE 8:                WHERE a.attrelid = '"suppliers"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  75) ManagementConsultancy::ServiceOffering is not valid if service_code is not in list of all service codes
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:71:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  76) ManagementConsultancy::ServiceOffering is not valid if service_code is blank
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:66:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  77) ManagementConsultancy::ServiceOffering is not valid if lot_number is blank
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:9:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  78) ManagementConsultancy::ServiceOffering 
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:6:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  79) ManagementConsultancy::ServiceOffering is not valid if lot_number is not in list of all lot numbers
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:14:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  80) ManagementConsultancy::ServiceOffering is valid even if offering exists for same lot_number & supplier, but different service_code
      Failure/Error: subject(:service_offering) { build(:management_consultancy_service_offering) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/service_offering_spec.rb:55:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  81) ManagementConsultancy::ServiceOffering looks up service based on its code
      Failure/Error: offering = build(:management_consultancy_service_offering, service_code: 'MCF1.2.1')

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "service_offerings" does not exist
        LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"service_offerings"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/service_offering_spec.rb:83:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "service_offerings" does not exist
      #   LINE 8:                WHERE a.attrelid = '"service_offerings"'::reg...
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  82) ManagementConsultancy::RateCard 
      Failure/Error: subject(:rate_card) { build(:management_consultancy_rate_card) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "rate_cards" does not exist
        LINE 8:                WHERE a.attrelid = '"rate_cards"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"rate_cards"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/rate_card_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/rate_card_spec.rb:6:in `block (2 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "rate_cards" does not exist
      #   LINE 8:                WHERE a.attrelid = '"rate_cards"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

  83) ManagementConsultancy::RateCard.average_daily_rate is expected to output the correct average
      Failure/Error: subject(:rate_card) { build(:management_consultancy_rate_card) }

      ActiveRecord::StatementInvalid:
        PG::UndefinedTable: ERROR:  relation "rate_cards" does not exist
        LINE 8:                WHERE a.attrelid = '"rate_cards"'::regclass
                                                  ^
        :               SELECT a.attname, format_type(a.atttypid, a.atttypmod),
                             pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod,
                             c.collname, col_description(a.attrelid, a.attnum) AS comment
                        FROM pg_attribute a
                        LEFT JOIN pg_attrdef d ON a.attrelid = d.adrelid AND a.attnum = d.adnum
                        LEFT JOIN pg_type t ON a.atttypid = t.oid
                        LEFT JOIN pg_collation c ON a.attcollation = c.oid AND a.attcollation <> t.typcollation
                       WHERE a.attrelid = '"rate_cards"'::regclass
                         AND a.attnum > 0 AND NOT a.attisdropped
                       ORDER BY a.attnum
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/invocation_tracker.rb:11:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:18:in `send'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator.rb:10:in `method_missing'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/configuration.rb:23:in `block in initialize'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `instance_exec'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:51:in `build_class_instance'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/attribute_assigner.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/evaluation.rb:13:in `object'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy/build.rb:9:in `result'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory.rb:43:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:29:in `block in run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/factory_runner.rb:28:in `run'
      # /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/strategy_syntax_method_registrar.rb:20:in `block in define_singular_strategy_method'
      # ./spec/models/management_consultancy/rate_card_spec.rb:4:in `block (2 levels) in <top (required)>'
      # ./spec/models/management_consultancy/rate_card_spec.rb:10:in `block (3 levels) in <top (required)>'
      # ------------------
      # --- Caused by: ---
      # PG::UndefinedTable:
      #   ERROR:  relation "rate_cards" does not exist
      #   LINE 8:                WHERE a.attrelid = '"rate_cards"'::regclass
      #                                             ^
      #   /Users/mike/.rvm/gems/ruby-2.5.3/gems/factory_bot-5.0.2/lib/factory_bot/decorator/new_constructor.rb:9:in `new'

Finished in 41.02 seconds (files took 3.92 seconds to load)
1383 examples, 83 failures

Failed examples:

rspec ./spec/models/management_consultancy/upload_spec.rb:288 # ManagementConsultancy::Upload create when data for one service is invalid raises ActiveRecord::RecordInvalid exception
rspec ./spec/models/management_consultancy/upload_spec.rb:294 # ManagementConsultancy::Upload create when data for one service is invalid does not create any suppliers
rspec ./spec/models/management_consultancy/upload_spec.rb:259 # ManagementConsultancy::Upload create when data for one lot is invalid raises ActiveRecord::RecordInvalid exception
rspec ./spec/models/management_consultancy/upload_spec.rb:265 # ManagementConsultancy::Upload create when data for one lot is invalid does not create any suppliers
rspec ./spec/models/management_consultancy/upload_spec.rb:179 # ManagementConsultancy::Upload create when suppliers already exist destroys all existing suppliers
rspec ./spec/models/management_consultancy/upload_spec.rb:205 # ManagementConsultancy::Upload create when suppliers already exist and data for one supplier is invalid leaves existing data intact
rspec ./spec/models/management_consultancy/upload_spec.rb:197 # ManagementConsultancy::Upload create when suppliers already exist and data for one supplier is invalid does not create record of unsuccessful upload
rspec ./spec/models/management_consultancy/upload_spec.rb:27 # ManagementConsultancy::Upload create when supplier list is empty does not create any suppliers
rspec ./spec/models/management_consultancy/upload_spec.rb:236 # ManagementConsultancy::Upload create when data for one supplier is invalid does not create any suppliers
rspec ./spec/models/management_consultancy/upload_spec.rb:230 # ManagementConsultancy::Upload create when data for one supplier is invalid raises ActiveRecord::RecordInvalid exception
rspec ./spec/models/management_consultancy/upload_spec.rb:54 # ManagementConsultancy::Upload create when supplier does not exist assigns attributes to supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:61 # ManagementConsultancy::Upload create when supplier does not exist assigns contact-related attributes to supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:35 # ManagementConsultancy::Upload create when supplier does not exist creates record of successful upload
rspec ./spec/models/management_consultancy/upload_spec.rb:47 # ManagementConsultancy::Upload create when supplier does not exist assigns ID to supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:41 # ManagementConsultancy::Upload create when supplier does not exist creates supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:157 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to second service offering
rspec ./spec/models/management_consultancy/upload_spec.rb:165 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to third service offering
rspec ./spec/models/management_consultancy/upload_spec.rb:149 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services assigns attributes to first service offering
rspec ./spec/models/management_consultancy/upload_spec.rb:143 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with services creates service offerings associated with supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:89 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions creates regional availabilities associated with supplier
rspec ./spec/models/management_consultancy/upload_spec.rb:113 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to third regional availability
rspec ./spec/models/management_consultancy/upload_spec.rb:104 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to second regional availability
rspec ./spec/models/management_consultancy/upload_spec.rb:95 # ManagementConsultancy::Upload create when supplier does not exist and supplier has lots with regions assigns attributes to first regional availability
rspec ./spec/services/management_consultancy/supplier_spreadsheet_creator_spec.rb:19 # ManagementConsultancy::SupplierSpreadsheetCreator.build returns an Axlsx::Package
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:43 # ManagementConsultancy::RegionalAvailability is valid even if availability exists for same region_code & supplier, but different lot_number
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:6 # ManagementConsultancy::RegionalAvailability 
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:65 # ManagementConsultancy::RegionalAvailability is not valid if region_code is blank
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:70 # ManagementConsultancy::RegionalAvailability is not valid if region_code is not in list of all region codes
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:54 # ManagementConsultancy::RegionalAvailability is valid even if availability exists for same lot_number & supplier, but different region_code
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:8 # ManagementConsultancy::RegionalAvailability is not valid if lot_number is blank
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:32 # ManagementConsultancy::RegionalAvailability is valid even if availability exists for same lot_number & region_code, but different supplier
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:76 # ManagementConsultancy::RegionalAvailability can be associated with one management consultancy supplier
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:19 # ManagementConsultancy::RegionalAvailability is not valid if availability exists for same lot_number, region_code & supplier
rspec ./spec/models/management_consultancy/regional_availability_spec.rb:13 # ManagementConsultancy::RegionalAvailability is not valid if lot_number is not in list of all lot numbers
rspec ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:25 # management_consultancy/suppliers/_supplier.html.erb displays the supplier name
rspec ./spec/views/management_consultancy/suppliers/_supplier.html.erb_spec.rb:35 # management_consultancy/suppliers/_supplier.html.erb when the supplier is an SME displays the SME label
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:58 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 assigns lot to the correct lot
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:62 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 renders the index template
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:66 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot2 assigns suppliers available in lot & regions, with services
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:37 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 assigns suppliers available in lot & regions, with services
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:33 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 renders the index template
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:41 # ManagementConsultancy::SuppliersController GET index when the lot answer is MCF2 lot1 assigns lot to the correct lot
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:88 # ManagementConsultancy::SuppliersController GET download renders the download template
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:109 # ManagementConsultancy::SuppliersController GET show with no lot number set renders the show template
rspec ./spec/controllers/management_consultancy/suppliers_controller_spec.rb:101 # ManagementConsultancy::SuppliersController GET show when the lot answer is MCF2 lot1 renders the show template
rspec ./spec/controllers/management_consultancy/uploads_controller_spec.rb:47 # ManagementConsultancy::UploadsController POST create when the app has upload privileges when model validation error occurs responds with 422 Unprocessable Entity
rspec ./spec/controllers/management_consultancy/uploads_controller_spec.rb:53 # ManagementConsultancy::UploadsController POST create when the app has upload privileges when model validation error occurs responds with JSON in body with details of the error
rspec ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:87 # Management consultancy Buyer wants to buy complex & transformation services (MCF2 Lot 3)
rspec ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:65 # Management consultancy Buyer wants to buy procurement, supply chain and commercial services (MCF2 Lot 2)
rspec ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:109 # Management consultancy Buyer wants to buy strategic services (MCF2 Lot 4)
rspec ./spec/features/management_consultancy/management_consultancy.feature_spec.rb:43 # Management consultancy Buyer wants to buy business consultancy services (MCF2 Lot 1)
rspec ./spec/models/management_consultancy/supplier_spec.rb:8 # ManagementConsultancy::Supplier is not valid if name is blank
rspec ./spec/models/management_consultancy/supplier_spec.rb:6 # ManagementConsultancy::Supplier 
rspec ./spec/models/management_consultancy/supplier_spec.rb:226 # ManagementConsultancy::Supplier.delete_all_with_dependents deletes all service offerings
rspec ./spec/models/management_consultancy/supplier_spec.rb:220 # ManagementConsultancy::Supplier.delete_all_with_dependents deletes all regional availabilities
rspec ./spec/models/management_consultancy/supplier_spec.rb:232 # ManagementConsultancy::Supplier.delete_all_with_dependents deletes all suppliers
rspec ./spec/models/management_consultancy/supplier_spec.rb:125 # ManagementConsultancy::Supplier.offering_services_in_regions when expenses are not paid excludes suppliers who require expenses
rspec ./spec/models/management_consultancy/supplier_spec.rb:118 # ManagementConsultancy::Supplier.offering_services_in_regions when expenses are paid returns suppliers with availability in lot and regions
rspec ./spec/models/management_consultancy/supplier_spec.rb:54 # ManagementConsultancy::Supplier.offering_services returns suppliers with availability in lot 1
rspec ./spec/models/management_consultancy/supplier_spec.rb:59 # ManagementConsultancy::Supplier.offering_services only returns suppliers that offer all services
rspec ./spec/models/management_consultancy/supplier_spec.rb:64 # ManagementConsultancy::Supplier.offering_services ignores services when there is a lot mismatch
rspec ./spec/models/management_consultancy/supplier_spec.rb:27 # ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF lot 2
rspec ./spec/models/management_consultancy/supplier_spec.rb:35 # ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF2 lot 3
rspec ./spec/models/management_consultancy/supplier_spec.rb:31 # ManagementConsultancy::Supplier.available_in_lot returns suppliers with availability in MCF 2 lot 2
rspec ./spec/models/management_consultancy/supplier_spec.rb:183 # ManagementConsultancy::Supplier.supplying_regions returns suppliers offering services in lot and regions
rspec ./spec/models/management_consultancy/supplier_spec.rb:193 # ManagementConsultancy::Supplier.supplying_regions only includes suppliers offering services in all specified regions
rspec ./spec/models/management_consultancy/supplier_spec.rb:198 # ManagementConsultancy::Supplier.supplying_regions returns multiple matching suppliers
rspec ./spec/models/management_consultancy/supplier_spec.rb:188 # ManagementConsultancy::Supplier.supplying_regions does not include suppliers offering services in a different lot
rspec ./spec/models/management_consultancy/supplier_spec.rb:158 # ManagementConsultancy::Supplier#services_in_lot returns services in lot 2
rspec ./spec/models/management_consultancy/supplier_spec.rb:154 # ManagementConsultancy::Supplier#services_in_lot returns services in lot 1
rspec ./spec/models/management_consultancy/service_offering_spec.rb:19 # ManagementConsultancy::ServiceOffering is not valid if offering exists for same lot_number, service_code & supplier
rspec ./spec/models/management_consultancy/service_offering_spec.rb:32 # ManagementConsultancy::ServiceOffering is valid even if offering exists for same lot_number & service_code, but different supplier
rspec ./spec/models/management_consultancy/service_offering_spec.rb:43 # ManagementConsultancy::ServiceOffering is valid even if offering exists for same service_code & supplier, but different lot_number
rspec ./spec/models/management_consultancy/service_offering_spec.rb:76 # ManagementConsultancy::ServiceOffering can be associated with one management consultancy supplier
rspec ./spec/models/management_consultancy/service_offering_spec.rb:70 # ManagementConsultancy::ServiceOffering is not valid if service_code is not in list of all service codes
rspec ./spec/models/management_consultancy/service_offering_spec.rb:65 # ManagementConsultancy::ServiceOffering is not valid if service_code is blank
rspec ./spec/models/management_consultancy/service_offering_spec.rb:8 # ManagementConsultancy::ServiceOffering is not valid if lot_number is blank
rspec ./spec/models/management_consultancy/service_offering_spec.rb:6 # ManagementConsultancy::ServiceOffering 
rspec ./spec/models/management_consultancy/service_offering_spec.rb:13 # ManagementConsultancy::ServiceOffering is not valid if lot_number is not in list of all lot numbers
rspec ./spec/models/management_consultancy/service_offering_spec.rb:54 # ManagementConsultancy::ServiceOffering is valid even if offering exists for same lot_number & supplier, but different service_code
rspec ./spec/models/management_consultancy/service_offering_spec.rb:82 # ManagementConsultancy::ServiceOffering looks up service based on its code
rspec ./spec/models/management_consultancy/rate_card_spec.rb:6 # ManagementConsultancy::RateCard 
rspec ./spec/models/management_consultancy/rate_card_spec.rb:9 # ManagementConsultancy::RateCard.average_daily_rate is expected to output the correct average

Randomized with seed 13132

Coverage report generated for RSpec to /Users/mike/master/coverage. 2617 / 3156 LOC (82.92%) covered.
