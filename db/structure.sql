SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: build_building_json(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.build_building_json() RETURNS trigger
    LANGUAGE plpgsql
    AS $$	begin
	        NEW.building_json := json_build_object(
                'id', NEW.id,
                'gia', COALESCE(NEW.gia,null),
                'name', COALESCE(NEW.building_name,''),
                'region', COALESCE(NEW.region,''),
                'address', json_build_object(
                  'building-ref', COALESCE(NEW.building_ref,''),
                  'fm-address-town', COALESCE(NEW.address_town,''),
                  'fm-address-county', COALESCE(NEW.address_county,''),
                  'fm-address-line-1', COALESCE(NEW.address_line_1,''),
                  'fm-address-line-2', COALESCE(NEW.address_line_2,''),
                  'fm-address-region', COALESCE(NEW.address_region,''),
                  'fm-address-postcode', COALESCE(NEW.address_postcode,''),
                  'fm-address-region-code', COALESCE(NEW.address_region_code,'')),
                'description', COALESCE(NEW.description,''),
                'building-ref', COALESCE(NEW.building_ref,''),
                'building-type', COALESCE(NEW.building_type,''),
                'security_type', COALESCE(NEW.security_type,'')
              );
         return NEW;
  END;
$$;


--
-- Name: extract_building_row_from_json(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.extract_building_row_from_json() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    NEW.gia := NEW.building_json ->> 'gia';
    NEW.building_name := NEW.building_json ->> 'name';
    NEW.description := NEW.building_json ->> 'description';
    NEW.region := NEW.building_json ->> 'region';
    NEW.building_ref := NEW.building_json ->> 'building-ref';
    NEW.building_type := NEW.building_json ->> 'building-type';
    NEW.security_type := NEW.building_json ->> 'security-type';
    NEW.address_town := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-town';
    NEW.address_county := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-county';
    NEW.address_line_1 := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-line-1';
    NEW.address_line_2 := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-line-2';
    NEW.address_region := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-region';
    NEW.address_postcode := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-postcode';
    NEW.address_region_code := (NEW.building_json -> 'address')::jsonb ->> 'fm-address-region-code';
     return NEW;
  END;
$$;


--
-- Name: update_building_status(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_building_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_status bool := false;
BEGIN
  new_status := COALESCE(NEW.building_name,'') <> '' and
                COALESCE(NEW.gia,-1) <> -1 and
                COALESCE(NEW.region,'') <> '' and
                COALESCE(NEW.building_type,'') <> '' and
                COALESCE(NEW.security_type,'') <> '' and
                COALESCE(NEW.building_ref,'') <> '';
   NEW.status := CASE WHEN new_status = true then 'Ready' else 'Incomplete' end;
   return new;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_management_buildings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_buildings (
    id uuid NOT NULL,
    user_id text NOT NULL,
    building_json jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying,
    updated_by character varying NOT NULL,
    building_ref text,
    building_name text,
    description text,
    gia numeric,
    region text,
    building_type text,
    security_type text,
    address_town text,
    address_county text,
    address_line_1 text,
    address_line_2 text,
    address_postcode text,
    address_region text,
    address_region_code text
);


--
-- Name: facilities_management_buyer_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_buyer_details (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    full_name character varying(255),
    job_title character varying(255),
    telephone_number character varying(255),
    organisation_name character varying(255),
    organisation_address_line_1 character varying(255),
    organisation_address_line_2 character varying(255),
    organisation_address_town character varying(255),
    organisation_address_county character varying(255),
    organisation_address_postcode character varying(255),
    central_government boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: facilities_management_procurement_building_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurement_building_services (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_procurement_building_id uuid NOT NULL,
    code character varying(10),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    no_of_appliances_for_testing integer,
    no_of_building_occupants integer,
    size_of_external_area integer,
    no_of_consoles_to_be_serviced integer,
    tones_to_be_collected_and_removed integer,
    no_of_units_to_be_serviced integer,
    service_standard character varying(1),
    lift_data character varying[] DEFAULT '{}'::character varying[],
    service_hours jsonb
);


--
-- Name: facilities_management_procurement_buildings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurement_buildings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_procurement_id uuid NOT NULL,
    service_codes text[] DEFAULT '{}'::text[],
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    town character varying(255),
    county character varying(255),
    postcode character varying(20),
    active boolean,
    building_id uuid
);


--
-- Name: facilities_management_procurement_contact_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurement_contact_details (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    type character varying(100),
    name character varying(50),
    job_title character varying(150),
    email text,
    telephone_number character varying(15),
    organisation_address_line_1 text,
    organisation_address_line_2 text,
    organisation_address_town text,
    organisation_address_county text,
    organisation_address_postcode text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    facilities_management_procurement_id uuid
);


--
-- Name: facilities_management_procurement_pension_funds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurement_pension_funds (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_procurement_id uuid NOT NULL,
    name character varying(150),
    percentage integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_management_procurement_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurement_suppliers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_procurement_id uuid NOT NULL,
    supplier_id uuid,
    direct_award_value money NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contract_number character varying,
    aasm_state character varying(30),
    offer_sent_date timestamp without time zone,
    supplier_response_date timestamp without time zone,
    contract_start_date timestamp without time zone,
    contract_end_date timestamp without time zone,
    contract_signed_date timestamp without time zone,
    contract_closed_date timestamp without time zone,
    reason_for_closing text,
    reason_for_declining text,
    reason_for_not_signing text
);


--
-- Name: facilities_management_procurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_procurements (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    aasm_state character varying(30),
    updated_by character varying(100),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    service_codes text[] DEFAULT '{}'::text[],
    region_codes text[] DEFAULT '{}'::text[],
    contract_name character varying(100),
    estimated_annual_cost integer,
    tupe boolean,
    initial_call_off_period integer,
    initial_call_off_start_date date,
    initial_call_off_end_date date,
    mobilisation_period integer,
    optional_call_off_extensions_1 integer,
    optional_call_off_extensions_2 integer,
    optional_call_off_extensions_3 integer,
    optional_call_off_extensions_4 integer,
    estimated_cost_known boolean,
    mobilisation_period_required boolean,
    extensions_required boolean,
    security_policy_document_required boolean,
    security_policy_document_name character varying,
    security_policy_document_version_number character varying,
    security_policy_document_date date,
    lot_number character varying,
    assessed_value money,
    eligible_for_da boolean,
    da_journey_state character varying,
    payment_method character varying,
    using_buyer_detail_for_invoice_details boolean,
    using_buyer_detail_for_notices_detail boolean,
    using_buyer_detail_for_authorised_detail boolean,
    local_government_pension_scheme boolean
);


--
-- Name: facilities_management_regional_availabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_regional_availabilities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_supplier_id uuid NOT NULL,
    lot_number text NOT NULL,
    region_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_management_service_offerings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_service_offerings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    facilities_management_supplier_id uuid NOT NULL,
    lot_number text NOT NULL,
    service_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_management_supplier_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_supplier_details (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    user_id uuid,
    name character varying(255),
    lot1a boolean,
    lot1b boolean,
    lot1c boolean,
    direct_award boolean,
    sme boolean,
    contact_name character varying(255),
    contact_email character varying(255),
    contact_number character varying(255),
    duns character varying(255),
    registration_number character varying(255),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    address_town character varying(255),
    address_county character varying(255),
    address_postcode character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facilities_management_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_suppliers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_name text,
    contact_email text,
    telephone_number text
);


--
-- Name: facilities_management_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facilities_management_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fm_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_cache (
    user_id text NOT NULL,
    key text NOT NULL,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fm_lifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_lifts (
    user_id text NOT NULL,
    building_id text NOT NULL,
    lift_data jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fm_rate_cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_rate_cards (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    data jsonb,
    source_file text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fm_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_rates (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    code character varying(5),
    framework numeric,
    benchmark numeric,
    standard character varying(1),
    direct_award boolean,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: fm_regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_regions (
    code text,
    name text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fm_security_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_security_types (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    sort_order integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fm_static_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_static_data (
    key character varying NOT NULL,
    value jsonb
);


--
-- Name: fm_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_suppliers (
    supplier_id uuid NOT NULL,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fm_units_of_measurement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_units_of_measurement (
    id integer NOT NULL,
    title_text character varying NOT NULL,
    example_text character varying,
    unit_text character varying,
    data_type character varying,
    spreadsheet_label character varying,
    unit_measure_label character varying,
    service_usage text[]
);


--
-- Name: fm_units_of_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fm_units_of_measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fm_units_of_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fm_units_of_measurement_id_seq OWNED BY public.fm_units_of_measurement.id;


--
-- Name: fm_uom_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fm_uom_values (
    user_id text,
    service_code text,
    uom_value text,
    building_id text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legal_services_admin_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_services_admin_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aasm_state character varying(15),
    suppliers character varying(255),
    supplier_lot_1_service_offerings character varying(255),
    supplier_lot_2_service_offerings character varying(255),
    supplier_lot_3_service_offerings character varying(255),
    supplier_lot_4_service_offerings character varying(255),
    rate_cards character varying(255),
    data jsonb,
    fail_reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    suppliers_data character varying
);


--
-- Name: legal_services_regional_availabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_services_regional_availabilities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    legal_services_supplier_id uuid NOT NULL,
    region_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    service_code character varying
);


--
-- Name: legal_services_service_offerings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_services_service_offerings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    legal_services_supplier_id uuid NOT NULL,
    lot_number text NOT NULL,
    service_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: legal_services_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_services_suppliers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text,
    phone_number text,
    website text,
    address text,
    sme boolean,
    duns integer,
    lot_1_prospectus_link text,
    lot_2_prospectus_link text,
    lot_3_prospectus_link text,
    lot_4_prospectus_link text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rate_cards jsonb
);


--
-- Name: legal_services_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_services_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: management_consultancy_admin_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_admin_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aasm_state character varying(15),
    fail_reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    suppliers_data character varying
);


--
-- Name: management_consultancy_rate_cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_rate_cards (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    management_consultancy_supplier_id uuid NOT NULL,
    lot character varying,
    junior_rate_in_pence integer,
    standard_rate_in_pence integer,
    senior_rate_in_pence integer,
    principal_rate_in_pence integer,
    managing_rate_in_pence integer,
    director_rate_in_pence integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_name character varying,
    telephone_number character varying,
    email character varying
);


--
-- Name: management_consultancy_regional_availabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_regional_availabilities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    management_consultancy_supplier_id uuid NOT NULL,
    lot_number text NOT NULL,
    region_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expenses_required boolean NOT NULL
);


--
-- Name: management_consultancy_service_offerings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_service_offerings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    management_consultancy_supplier_id uuid NOT NULL,
    lot_number text NOT NULL,
    service_code text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: management_consultancy_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_suppliers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_name text,
    contact_email text,
    telephone_number text,
    sme boolean,
    address character varying,
    website character varying,
    duns integer
);


--
-- Name: management_consultancy_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.management_consultancy_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nuts_regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nuts_regions (
    code character varying(255),
    name character varying(255),
    nuts1_code character varying(255),
    nuts2_code character varying(255)
);


--
-- Name: os_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.os_address (
    uprn bigint NOT NULL,
    udprn bigint,
    change_type character varying,
    state bigint,
    state_date date,
    class character varying,
    parent_uprn bigint,
    x_coordinate numeric,
    y_coordinate numeric,
    latitude numeric,
    longitude numeric,
    rpc bigint,
    local_custodian_code bigint,
    country character varying,
    la_start_date date,
    last_update_date date,
    entry_date date,
    rm_organisation_name character varying,
    la_organisation character varying,
    department_name character varying,
    legal_name character varying,
    sub_building_name character varying,
    building_name character varying,
    building_number character varying,
    sao_start_number bigint,
    sao_start_suffix character varying,
    sao_end_number bigint,
    sao_end_suffix character varying,
    sao_text character varying,
    alt_language_sao_text character varying,
    pao_start_number bigint,
    pao_start_suffix character varying,
    pao_end_number bigint,
    pao_end_suffix character varying,
    pao_text character varying,
    alt_language_pao_text character varying,
    usrn bigint,
    usrn_match_indicator character varying,
    area_name character varying,
    level character varying,
    official_flag character varying,
    os_address_toid character varying,
    os_address_toid_version bigint,
    os_roadlink_toid character varying,
    os_roadlink_toid_version bigint,
    os_topo_toid character varying,
    os_topo_toid_version bigint,
    voa_ct_record bigint,
    voa_ndr_record bigint,
    street_description character varying,
    alt_language_street_description character varying,
    dependent_thoroughfare character varying,
    thoroughfare character varying,
    welsh_dependent_thoroughfare character varying,
    welsh_thoroughfare character varying,
    double_dependent_locality character varying,
    dependent_locality character varying,
    locality character varying,
    welsh_dependent_locality character varying,
    welsh_double_dependent_locality character varying,
    town_name character varying,
    administrative_area character varying,
    post_town character varying,
    welsh_post_town character varying,
    postcode character varying,
    postcode_locator character varying,
    postcode_type character varying,
    delivery_point_suffix character varying,
    addressbase_postal character varying,
    po_box_number character varying,
    ward_code character varying,
    parish_code character varying,
    rm_start_date date,
    multi_occ_count bigint,
    voa_ndr_p_desc_code character varying,
    voa_ndr_scat_code character varying,
    alt_language character varying
);


--
-- Name: os_address_admin_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.os_address_admin_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    filename character varying(255),
    size integer,
    etag character varying(255),
    fail_reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: os_address_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.os_address_view AS
 SELECT btrim((((((NULLIF((adds.rm_organisation_name)::text, ' '::text) || ' '::text) || adds.pao_start_number) || (adds.pao_start_suffix)::text) || ' '::text) || (adds.street_description)::text)) AS add1,
    adds.town_name AS village,
    adds.post_town,
    adds.administrative_area AS county,
    adds.postcode,
    replace((adds.postcode)::text, ' '::text, ''::text) AS formated_postcode,
    replace((adds.postcode)::text, ' '::text, (adds.delivery_point_suffix)::text) AS building_ref
   FROM public.os_address adds
  WHERE ((((adds.pao_start_number || (adds.pao_start_suffix)::text) || (adds.street_description)::text) IS NOT NULL) AND (adds.post_town IS NOT NULL))
  ORDER BY adds.pao_start_number, adds.rm_organisation_name, adds.street_description;


--
-- Name: postcodes_nuts_regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.postcodes_nuts_regions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    postcode character varying(20),
    code character varying(20),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: supply_teachers_admin_current_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_admin_current_data (
    id bigint NOT NULL,
    current_accredited_suppliers character varying(255),
    geographical_data_all_suppliers character varying(255),
    lot_1_and_lot_2_comparisons character varying(255),
    master_vendor_contacts character varying(255),
    neutral_vendor_contacts character varying(255),
    pricing_for_tool character varying(255),
    supplier_lookup character varying(255),
    data character varying(255),
    error text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: supply_teachers_admin_current_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supply_teachers_admin_current_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supply_teachers_admin_current_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supply_teachers_admin_current_data_id_seq OWNED BY public.supply_teachers_admin_current_data.id;


--
-- Name: supply_teachers_admin_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_admin_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aasm_state character varying(15),
    current_accredited_suppliers character varying(255),
    geographical_data_all_suppliers character varying(255),
    lot_1_and_lot_2_comparisons character varying(255),
    master_vendor_contacts character varying(255),
    neutral_vendor_contacts character varying(255),
    pricing_for_tool character varying(255),
    supplier_lookup character varying(255),
    fail_reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: supply_teachers_branches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_branches (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    supply_teachers_supplier_id uuid NOT NULL,
    postcode character varying(8) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location public.geography(Point,4326),
    contact_name text,
    contact_email text,
    telephone_number text,
    name text,
    town text,
    address_1 character varying,
    address_2 character varying,
    county character varying,
    region character varying,
    slug character varying
);


--
-- Name: supply_teachers_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_rates (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    supply_teachers_supplier_id uuid NOT NULL,
    job_type text NOT NULL,
    mark_up double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    term text,
    lot_number integer DEFAULT 1 NOT NULL,
    daily_fee money
);


--
-- Name: supply_teachers_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_suppliers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    neutral_vendor_contact_name text,
    neutral_vendor_telephone_number text,
    neutral_vendor_contact_email text,
    master_vendor_contact_name text,
    master_vendor_telephone_number text,
    master_vendor_contact_email text
);


--
-- Name: supply_teachers_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_teachers_uploads (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    phone_number character varying(255),
    mobile_number character varying(255),
    confirmed_at timestamp without time zone,
    cognito_uuid character varying(255),
    roles_mask integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: fm_units_of_measurement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fm_units_of_measurement ALTER COLUMN id SET DEFAULT nextval('public.fm_units_of_measurement_id_seq'::regclass);


--
-- Name: supply_teachers_admin_current_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_admin_current_data ALTER COLUMN id SET DEFAULT nextval('public.supply_teachers_admin_current_data_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: facilities_management_buildings facilities_management_buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_buildings
    ADD CONSTRAINT facilities_management_buildings_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_buyer_details facilities_management_buyer_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_buyer_details
    ADD CONSTRAINT facilities_management_buyer_details_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_building_services facilities_management_procurement_building_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_building_services
    ADD CONSTRAINT facilities_management_procurement_building_services_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_buildings facilities_management_procurement_buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_buildings
    ADD CONSTRAINT facilities_management_procurement_buildings_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_contact_details facilities_management_procurement_contact_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_contact_details
    ADD CONSTRAINT facilities_management_procurement_contact_details_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_pension_funds facilities_management_procurement_pension_funds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_pension_funds
    ADD CONSTRAINT facilities_management_procurement_pension_funds_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_suppliers facilities_management_procurement_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_suppliers
    ADD CONSTRAINT facilities_management_procurement_suppliers_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurements facilities_management_procurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurements
    ADD CONSTRAINT facilities_management_procurements_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_regional_availabilities facilities_management_regional_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_regional_availabilities
    ADD CONSTRAINT facilities_management_regional_availabilities_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_service_offerings facilities_management_service_offerings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_service_offerings
    ADD CONSTRAINT facilities_management_service_offerings_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_supplier_details facilities_management_supplier_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_supplier_details
    ADD CONSTRAINT facilities_management_supplier_details_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_suppliers facilities_management_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_suppliers
    ADD CONSTRAINT facilities_management_suppliers_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_uploads facilities_management_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_uploads
    ADD CONSTRAINT facilities_management_uploads_pkey PRIMARY KEY (id);


--
-- Name: fm_rate_cards fm_rate_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fm_rate_cards
    ADD CONSTRAINT fm_rate_cards_pkey PRIMARY KEY (id);


--
-- Name: fm_rates fm_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fm_rates
    ADD CONSTRAINT fm_rates_pkey PRIMARY KEY (id);


--
-- Name: fm_security_types fm_security_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fm_security_types
    ADD CONSTRAINT fm_security_types_pkey PRIMARY KEY (id);


--
-- Name: fm_suppliers fm_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fm_suppliers
    ADD CONSTRAINT fm_suppliers_pkey PRIMARY KEY (supplier_id);


--
-- Name: legal_services_admin_uploads legal_services_admin_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_admin_uploads
    ADD CONSTRAINT legal_services_admin_uploads_pkey PRIMARY KEY (id);


--
-- Name: legal_services_regional_availabilities legal_services_regional_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_regional_availabilities
    ADD CONSTRAINT legal_services_regional_availabilities_pkey PRIMARY KEY (id);


--
-- Name: legal_services_service_offerings legal_services_service_offerings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_service_offerings
    ADD CONSTRAINT legal_services_service_offerings_pkey PRIMARY KEY (id);


--
-- Name: legal_services_suppliers legal_services_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_suppliers
    ADD CONSTRAINT legal_services_suppliers_pkey PRIMARY KEY (id);


--
-- Name: legal_services_uploads legal_services_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_uploads
    ADD CONSTRAINT legal_services_uploads_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_admin_uploads management_consultancy_admin_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_admin_uploads
    ADD CONSTRAINT management_consultancy_admin_uploads_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_rate_cards management_consultancy_rate_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_rate_cards
    ADD CONSTRAINT management_consultancy_rate_cards_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_regional_availabilities management_consultancy_regional_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_regional_availabilities
    ADD CONSTRAINT management_consultancy_regional_availabilities_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_service_offerings management_consultancy_service_offerings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_service_offerings
    ADD CONSTRAINT management_consultancy_service_offerings_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_suppliers management_consultancy_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_suppliers
    ADD CONSTRAINT management_consultancy_suppliers_pkey PRIMARY KEY (id);


--
-- Name: management_consultancy_uploads management_consultancy_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_uploads
    ADD CONSTRAINT management_consultancy_uploads_pkey PRIMARY KEY (id);


--
-- Name: os_address_admin_uploads os_address_admin_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.os_address_admin_uploads
    ADD CONSTRAINT os_address_admin_uploads_pkey PRIMARY KEY (id);


--
-- Name: postcodes_nuts_regions postcodes_nuts_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postcodes_nuts_regions
    ADD CONSTRAINT postcodes_nuts_regions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: supply_teachers_admin_current_data supply_teachers_admin_current_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_admin_current_data
    ADD CONSTRAINT supply_teachers_admin_current_data_pkey PRIMARY KEY (id);


--
-- Name: supply_teachers_admin_uploads supply_teachers_admin_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_admin_uploads
    ADD CONSTRAINT supply_teachers_admin_uploads_pkey PRIMARY KEY (id);


--
-- Name: supply_teachers_branches supply_teachers_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_branches
    ADD CONSTRAINT supply_teachers_branches_pkey PRIMARY KEY (id);


--
-- Name: supply_teachers_rates supply_teachers_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_rates
    ADD CONSTRAINT supply_teachers_rates_pkey PRIMARY KEY (id);


--
-- Name: supply_teachers_suppliers supply_teachers_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_suppliers
    ADD CONSTRAINT supply_teachers_suppliers_pkey PRIMARY KEY (id);


--
-- Name: supply_teachers_uploads supply_teachers_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_uploads
    ADD CONSTRAINT supply_teachers_uploads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: facilities_management_procurement_contact_detail_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX facilities_management_procurement_contact_detail_email_idx ON public.facilities_management_procurement_contact_details USING btree (email);


--
-- Name: facilities_management_procurement_contact_detail_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX facilities_management_procurement_contact_detail_id_idx ON public.facilities_management_procurement_contact_details USING btree (id);


--
-- Name: fm_cache_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fm_cache_user_id_idx ON public.fm_cache USING btree (user_id, key);


--
-- Name: fm_lifts_lift_json; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fm_lifts_lift_json ON public.fm_lifts USING gin (((lift_data -> 'floor-data'::text)));


--
-- Name: fm_lifts_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fm_lifts_user_id_idx ON public.fm_lifts USING btree (user_id, building_id);


--
-- Name: fm_regions_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX fm_regions_code_key ON public.fm_regions USING btree (code);


--
-- Name: fm_static_data_key_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fm_static_data_key_idx ON public.fm_static_data USING btree (key);


--
-- Name: fm_uom_values_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fm_uom_values_user_id_idx ON public.fm_uom_values USING btree (user_id, service_code, building_id);


--
-- Name: idx_buildings_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_gin ON public.facilities_management_buildings USING gin (building_json);


--
-- Name: idx_buildings_ginp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_ginp ON public.facilities_management_buildings USING gin (building_json jsonb_path_ops);


--
-- Name: idx_buildings_service; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_service ON public.facilities_management_buildings USING gin (((building_json -> 'services'::text)));


--
-- Name: idx_buildings_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_buildings_user_id ON public.facilities_management_buildings USING btree (user_id);


--
-- Name: idx_fm_rate_cards_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fm_rate_cards_gin ON public.fm_rate_cards USING gin (data);


--
-- Name: idx_fm_rate_cards_ginp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fm_rate_cards_ginp ON public.fm_rate_cards USING gin (data jsonb_path_ops);


--
-- Name: idx_postcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_postcode ON public.os_address USING btree (postcode);


--
-- Name: idxgin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxgin ON public.fm_suppliers USING gin (data);


--
-- Name: idxginlots; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxginlots ON public.fm_suppliers USING gin (((data -> 'lots'::text)));


--
-- Name: idxginp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idxginp ON public.fm_suppliers USING gin (data jsonb_path_ops);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_facilities_management_buildings_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_facilities_management_buildings_on_id ON public.facilities_management_buildings USING btree (id);


--
-- Name: index_facilities_management_buyer_details_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_facilities_management_buyer_details_on_user_id ON public.facilities_management_buyer_details USING btree (user_id);


--
-- Name: index_facilities_management_procurements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_facilities_management_procurements_on_user_id ON public.facilities_management_procurements USING btree (user_id);


--
-- Name: index_facilities_management_supplier_details_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_facilities_management_supplier_details_on_user_id ON public.facilities_management_supplier_details USING btree (user_id);


--
-- Name: index_fm_procurement_contact_details_on_fm_procurement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_procurement_contact_details_on_fm_procurement_id ON public.facilities_management_procurement_contact_details USING btree (facilities_management_procurement_id);


--
-- Name: index_fm_procurement_pension_funds_on_fm_procurement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_procurement_pension_funds_on_fm_procurement_id ON public.facilities_management_procurement_pension_funds USING btree (facilities_management_procurement_id);


--
-- Name: index_fm_procurement_supplier_on_fm_procurement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_procurement_supplier_on_fm_procurement_id ON public.facilities_management_procurement_suppliers USING btree (facilities_management_procurement_id);


--
-- Name: index_fm_procurements_on_fm_procurement_building_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_procurements_on_fm_procurement_building_id ON public.facilities_management_procurement_building_services USING btree (facilities_management_procurement_building_id);


--
-- Name: index_fm_procurements_on_fm_procurement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_procurements_on_fm_procurement_id ON public.facilities_management_procurement_buildings USING btree (facilities_management_procurement_id);


--
-- Name: index_fm_rates_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_rates_on_code ON public.fm_rates USING btree (code);


--
-- Name: index_fm_regional_availabilities_on_fm_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_regional_availabilities_on_fm_supplier_id ON public.facilities_management_regional_availabilities USING btree (facilities_management_supplier_id);


--
-- Name: index_fm_regional_availabilities_on_lot_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_regional_availabilities_on_lot_number ON public.facilities_management_regional_availabilities USING btree (lot_number);


--
-- Name: index_fm_security_types_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_security_types_on_id ON public.fm_security_types USING btree (id);


--
-- Name: index_fm_service_offerings_on_fm_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_service_offerings_on_fm_supplier_id ON public.facilities_management_service_offerings USING btree (facilities_management_supplier_id);


--
-- Name: index_fm_service_offerings_on_lot_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fm_service_offerings_on_lot_number ON public.facilities_management_service_offerings USING btree (lot_number);


--
-- Name: index_legal_services_suppliers_on_rate_cards; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_legal_services_suppliers_on_rate_cards ON public.legal_services_suppliers USING gin (rate_cards);


--
-- Name: index_ls_regional_availabilities_on_ls_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ls_regional_availabilities_on_ls_supplier_id ON public.legal_services_regional_availabilities USING btree (legal_services_supplier_id);


--
-- Name: index_ls_service_offerings_on_ls_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ls_service_offerings_on_ls_supplier_id ON public.legal_services_service_offerings USING btree (legal_services_supplier_id);


--
-- Name: index_management_consultancy_rate_cards_on_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_management_consultancy_rate_cards_on_supplier_id ON public.management_consultancy_rate_cards USING btree (management_consultancy_supplier_id);


--
-- Name: index_mc_regional_availabilities_on_mc_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mc_regional_availabilities_on_mc_supplier_id ON public.management_consultancy_regional_availabilities USING btree (management_consultancy_supplier_id);


--
-- Name: index_mc_service_offerings_on_mc_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mc_service_offerings_on_mc_supplier_id ON public.management_consultancy_service_offerings USING btree (management_consultancy_supplier_id);


--
-- Name: index_postcodes_nuts_regions_on_postcode; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_postcodes_nuts_regions_on_postcode ON public.postcodes_nuts_regions USING btree (postcode);


--
-- Name: index_supply_teachers_branches_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_supply_teachers_branches_on_slug ON public.supply_teachers_branches USING btree (slug);


--
-- Name: index_supply_teachers_branches_on_supply_teachers_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_supply_teachers_branches_on_supply_teachers_supplier_id ON public.supply_teachers_branches USING btree (supply_teachers_supplier_id);


--
-- Name: index_supply_teachers_rates_on_supply_teachers_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_supply_teachers_rates_on_supply_teachers_supplier_id ON public.supply_teachers_rates USING btree (supply_teachers_supplier_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: nuts_regions_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX nuts_regions_code_key ON public.nuts_regions USING btree (code);


--
-- Name: os_address_admin_uploads_filename_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX os_address_admin_uploads_filename_idx ON public.os_address_admin_uploads USING btree (filename);


--
-- Name: facilities_management_buildings create_building_json; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER create_building_json BEFORE INSERT ON public.facilities_management_buildings FOR EACH ROW WHEN (((new.building_json = '"{}"'::jsonb) OR (COALESCE(new.building_json, '{}'::jsonb) = '{}'::jsonb))) EXECUTE FUNCTION public.build_building_json();


--
-- Name: facilities_management_buildings create_building_json_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER create_building_json_on_update BEFORE UPDATE OF status, updated_by, building_ref, building_name, description, gia, region, building_type, security_type, address_town, address_county, address_line_1, address_line_2, address_postcode, address_region, address_region_code ON public.facilities_management_buildings FOR EACH ROW EXECUTE FUNCTION public.build_building_json();


--
-- Name: facilities_management_buildings insert_building_from_json; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER insert_building_from_json BEFORE INSERT ON public.facilities_management_buildings FOR EACH ROW WHEN (((new.building_json <> '"{}"'::jsonb) OR (COALESCE(new.building_json, '{}'::jsonb) <> '{}'::jsonb))) EXECUTE FUNCTION public.extract_building_row_from_json();


--
-- Name: facilities_management_buildings update_building_from_json; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_building_from_json BEFORE UPDATE OF building_json ON public.facilities_management_buildings FOR EACH ROW EXECUTE FUNCTION public.extract_building_row_from_json();


--
-- Name: facilities_management_buildings update_building_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_building_status BEFORE INSERT OR UPDATE ON public.facilities_management_buildings FOR EACH ROW EXECUTE FUNCTION public.update_building_status();


--
-- Name: management_consultancy_rate_cards fk_rails_32e9463972; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_rate_cards
    ADD CONSTRAINT fk_rails_32e9463972 FOREIGN KEY (management_consultancy_supplier_id) REFERENCES public.management_consultancy_suppliers(id);


--
-- Name: facilities_management_procurement_buildings fk_rails_3814b5dc1a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_buildings
    ADD CONSTRAINT fk_rails_3814b5dc1a FOREIGN KEY (facilities_management_procurement_id) REFERENCES public.facilities_management_procurements(id);


--
-- Name: facilities_management_procurement_pension_funds fk_rails_41a22e28d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_pension_funds
    ADD CONSTRAINT fk_rails_41a22e28d4 FOREIGN KEY (facilities_management_procurement_id) REFERENCES public.facilities_management_procurements(id);


--
-- Name: legal_services_service_offerings fk_rails_42f82c34fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_service_offerings
    ADD CONSTRAINT fk_rails_42f82c34fb FOREIGN KEY (legal_services_supplier_id) REFERENCES public.legal_services_suppliers(id);


--
-- Name: management_consultancy_service_offerings fk_rails_56a289ab28; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_service_offerings
    ADD CONSTRAINT fk_rails_56a289ab28 FOREIGN KEY (management_consultancy_supplier_id) REFERENCES public.management_consultancy_suppliers(id);


--
-- Name: facilities_management_service_offerings fk_rails_5e1d3ac75d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_service_offerings
    ADD CONSTRAINT fk_rails_5e1d3ac75d FOREIGN KEY (facilities_management_supplier_id) REFERENCES public.facilities_management_suppliers(id);


--
-- Name: legal_services_regional_availabilities fk_rails_6de910d258; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_services_regional_availabilities
    ADD CONSTRAINT fk_rails_6de910d258 FOREIGN KEY (legal_services_supplier_id) REFERENCES public.legal_services_suppliers(id);


--
-- Name: facilities_management_procurement_contact_details fk_rails_8143a03319; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_contact_details
    ADD CONSTRAINT fk_rails_8143a03319 FOREIGN KEY (facilities_management_procurement_id) REFERENCES public.facilities_management_procurements(id);


--
-- Name: facilities_management_procurement_suppliers fk_rails_894f63bbc0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_suppliers
    ADD CONSTRAINT fk_rails_894f63bbc0 FOREIGN KEY (facilities_management_procurement_id) REFERENCES public.facilities_management_procurements(id);


--
-- Name: management_consultancy_regional_availabilities fk_rails_8d8a6a8827; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.management_consultancy_regional_availabilities
    ADD CONSTRAINT fk_rails_8d8a6a8827 FOREIGN KEY (management_consultancy_supplier_id) REFERENCES public.management_consultancy_suppliers(id);


--
-- Name: supply_teachers_branches fk_rails_91c22195e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_branches
    ADD CONSTRAINT fk_rails_91c22195e1 FOREIGN KEY (supply_teachers_supplier_id) REFERENCES public.supply_teachers_suppliers(id);


--
-- Name: facilities_management_regional_availabilities fk_rails_985c70cce4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_regional_availabilities
    ADD CONSTRAINT fk_rails_985c70cce4 FOREIGN KEY (facilities_management_supplier_id) REFERENCES public.facilities_management_suppliers(id);


--
-- Name: facilities_management_supplier_details fk_rails_9bc28c85c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_supplier_details
    ADD CONSTRAINT fk_rails_9bc28c85c2 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: facilities_management_buyer_details fk_rails_9bc7691d89; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_buyer_details
    ADD CONSTRAINT fk_rails_9bc7691d89 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: facilities_management_procurements fk_rails_c1d83fe850; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurements
    ADD CONSTRAINT fk_rails_c1d83fe850 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: supply_teachers_rates fk_rails_caaa35ac66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_teachers_rates
    ADD CONSTRAINT fk_rails_caaa35ac66 FOREIGN KEY (supply_teachers_supplier_id) REFERENCES public.supply_teachers_suppliers(id);


--
-- Name: facilities_management_procurement_building_services fk_rails_e686bb4678; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facilities_management_procurement_building_services
    ADD CONSTRAINT fk_rails_e686bb4678 FOREIGN KEY (facilities_management_procurement_building_id) REFERENCES public.facilities_management_procurement_buildings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181004100253'),
('20181004100503'),
('20181004100733'),
('20181004124616'),
('20181004130412'),
('20181009104806'),
('20181009113439'),
('20181010170734'),
('20181011132200'),
('20181011134015'),
('20181011135925'),
('20181015101044'),
('20181016161033'),
('20181017115202'),
('20181017152819'),
('20181018161626'),
('20181024091756'),
('20181031183251'),
('20181031185939'),
('20181031191036'),
('20181031191820'),
('20181031200527'),
('20181105142503'),
('20181105142644'),
('20181105170817'),
('20181113133921'),
('20181113140044'),
('20181113163200'),
('20181114181626'),
('20181119160741'),
('20181120114606'),
('20181206152712'),
('20181210112501'),
('20181210121631'),
('20181210122557'),
('20190315144216'),
('20190318122002'),
('20190320114608'),
('20190325092205'),
('20190412144942'),
('20190509132528'),
('20190515152412'),
('20190517155302'),
('20190521111111'),
('20190605110142'),
('20190703092720'),
('20190716130322'),
('20190724080235'),
('20190724080301'),
('20190724080315'),
('20190724080329'),
('20190724080343'),
('20190724080344'),
('20190724080357'),
('20190724080410'),
('20190724080425'),
('20190724080439'),
('20190807100908'),
('20190807105654'),
('20190807111201'),
('20190808132209'),
('20190815101211'),
('20190816162029'),
('20190820101225'),
('20190820103623'),
('20190820133209'),
('20190820133859'),
('20190820135101'),
('20190821200501'),
('20190822085512'),
('20190829114901'),
('20190829114911'),
('20190902143001'),
('20190903155115'),
('20190904142234'),
('20190911140213'),
('20190916132808'),
('20190917090520'),
('20190917091020'),
('20190917111950'),
('20190918112324'),
('20190918155522'),
('20190919101129'),
('20190919152002'),
('20191001122201'),
('20191002145423'),
('20191009152026'),
('20191017103501'),
('20191018180155'),
('20191018183421'),
('20191023090757'),
('20191023113909'),
('20191023114416'),
('20191025152610'),
('20191030173705'),
('20191031124754'),
('20191031153244'),
('20191031165100'),
('20191113162339'),
('20191118164814'),
('20191121102422'),
('20191121104947'),
('20191220134549'),
('20191223113007'),
('20191230124912'),
('20200103131101'),
('20200113193447'),
('20200115160444'),
('20200117125836'),
('20200117134702'),
('20200120153957'),
('20200121102051'),
('20200121135030'),
('20200123092237'),
('20200123101511'),
('20200123102034'),
('20200123152430'),
('20200124084544'),
('20200127084322'),
('20200127104344'),
('20200203170223'),
('20200226154807'),
('20200302162216'),
('20200302162623'),
('20200309111231'),
('20200311113711'),
('20200318140756'),
('20200318142425'),
('20200319112029'),
('20200319113541'),
('20200320150617'),
('20200326155639');


