#! /bin/sh
echo Chunking postcode files
zip=0
tar=0
csv=0
keep=0
ext=dat
if [[ -n "$1" ]]; then
  while [ -n "$1" ]; do
    case "$1" in
    -zip)
      zip=1
      tar=0
      ;;
    -tar)
      tar=1
      zip=0
      ;;
    -csv)
      csv=1
      ext=csv
      ;;
    -keep)
      keep=1;;
    esac
    shift
  done
else
  echo "You can pass in -zip|tar [-keep] and -csv options."
  echo "\t-csv will add the OS_ADDRESS headers to each file"
  echo "\t-zip will compress each output file using zip"
  echo "\t-tar will compress to produce .tar.gz files"
  echo "\t-keep will produce zip and dat/csv outputs"
  echo Processing files without headers and no final compression
fi
if [ $csv = 1 ]; then
  echo Creating CSV files
else
  echo Creating DAT files
fi
if [ $zip = 1 ]; then
  echo Creating zips
  if [ $keep = 1 ]; then
    if [ $csv = 1 ]; then
      echo "Keeping CSV files as well as the zip file"
    else
      echo "Keeping DAT files as well as the zip file"
    fi
  fi
else
  if [ $tar = 1 ]; then
    echo Creating tars
    if [ $keep = 1 ]; then
      if [ $csv = 1 ]; then
        echo "Keeping CSV files as well as the tar.gz file"
      else
        echo "Keeping DAT files as well as the tar.gz file"
      fi
    fi
  else
    echo Creating uncompressed files
  fi
fi

for file in AddressBasePlus_FULL*.csv; do
  # shellcheck disable=SC2039
  if [[ -f "$file" ]]; then
    # process the file with name in "$file" here
    if [[ "$file" == *".csv"* ]]; then
      pname="p_${file%.*}"
      finished_name="dataPostcode_${file:21:14}"
      echo Parsing "$file -> $finished_name"*.csv

      [[ -f "$pname.csv" ]] && { echo csvquote done for $file; } || {
        echo csvquote on $file
        csvquote $file >"$pname.csv"
      }
      echo Splitting "$pname".csv
      awk -F "," '{match($66, /([A-Z][A-Z]{0,1})/, outcode); print > (substr(FILENAME,0,length(FILENAME)-4)"-"outcode[0]".awk")}' "$pname.csv"
      echo Producing final output for $file

      for awkfile in "$pname"*.awk; do
        awksuffix=${awkfile:38:2}
        if [[ "${awkfile:39:1}" = "." ]]; then
          awksuffix=${awkfile:38:1}
        fi
        echo "${finished_name}_${awksuffix}.${ext}"
        [[ $csv = 1 ]] && echo "UPRN,UDPRN,CHANGE_TYPE,STATE,STATE_DATE,CLASS,PARENT_UPRN,X_COORDINATE,Y_COORDINATE,LATITUDE,LONGITUDE,RPC,LOCAL_CUSTODIAN_CODE,COUNTRY,LA_START_DATE,LAST_UPDATE_DATE,ENTRY_DATE,RM_ORGANISATION_NAME,LA_ORGANISATION,DEPARTMENT_NAME,LEGAL_NAME,SUB_BUILDING_NAME,BUILDING_NAME,BUILDING_NUMBER,SAO_START_NUMBER,SAO_START_SUFFIX,SAO_END_NUMBER,SAO_END_SUFFIX,SAO_TEXT,ALT_LANGUAGE_SAO_TEXT,PAO_START_NUMBER,PAO_START_SUFFIX,PAO_END_NUMBER,PAO_END_SUFFIX,PAO_TEXT,ALT_LANGUAGE_PAO_TEXT,USRN,USRN_MATCH_INDICATOR,AREA_NAME,LEVEL,OFFICIAL_FLAG,OS_ADDRESS_TOID,OS_ADDRESS_TOID_VERSION,OS_ROADLINK_TOID,OS_ROADLINK_TOID_VERSION,OS_TOPO_TOID,OS_TOPO_TOID_VERSION,VOA_CT_RECORD,VOA_NDR_RECORD,STREET_DESCRIPTION,ALT_LANGUAGE_STREET_DESCRIPTION,DEPENDENT_THOROUGHFARE,THOROUGHFARE,WELSH_DEPENDENT_THOROUGHFARE,WELSH_THOROUGHFARE,DOUBLE_DEPENDENT_LOCALITY,DEPENDENT_LOCALITY,LOCALITY,WELSH_DEPENDENT_LOCALITY,WELSH_DOUBLE_DEPENDENT_LOCALITY,TOWN_NAME,ADMINISTRATIVE_AREA,POST_TOWN,WELSH_POST_TOWN,POSTCODE,POSTCODE_LOCATOR,POSTCODE_TYPE,DELIVERY_POINT_SUFFIX,ADDRESSBASE_POSTAL,PO_BOX_NUMBER,WARD_CODE,PARISH_CODE,RM_START_DATE,MULTI_OCC_COUNT,VOA_NDR_P_DESC_CODE,VOA_NDR_SCAT_CODE,ALT_LANGUAGE" > "${finished_name}_${awksuffix}.${ext}"
        csvquote -u "$awkfile" >> "${finished_name}_${awksuffix}.${ext}"
        rm "$awkfile"
        if [[ $zip = 1 ]]; then
          zip "${finished_name}_${awksuffix}.${ext}.zip" "${finished_name}_${awksuffix}.${ext}";
        fi
        if [[ $tar = 1 ]]; then
          tar -zc --options "gzip:compression-level=9" -f "${finished_name}_${awksuffix}.${ext}.tar.gz" "${finished_name}_${awksuffix}.${ext}";
        fi
        [[ $keep -ne 1 ]] && rm "${finished_name}_${awksuffix}.${ext}"
      done

      rm "$pname.csv"
    fi
  fi
  echo Done
done
