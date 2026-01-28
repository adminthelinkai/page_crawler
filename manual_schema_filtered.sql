--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--




--
-- Name: approval_decision; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.approval_decision AS ENUM (
    'approved',
    'rejected',
    'requested_changes'
);


ALTER TYPE public.approval_decision OWNER TO supabase_admin;

--
-- Name: approval_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.approval_status AS ENUM (
    'pending',
    'reviewed',
    'approved',
    'rejected',
    'returned_for_revision'
);


ALTER TYPE public.approval_status OWNER TO supabase_admin;

--
-- Name: approval_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.approval_type AS ENUM (
    'task_completion',
    'decision_consensus',
    'deliverable',
    'direction_change',
    'tool_result_validation'
);


ALTER TYPE public.approval_type OWNER TO supabase_admin;

--
-- Name: approvaldecision; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.approvaldecision AS ENUM (
    'APPROVED',
    'REJECTED',
    'REQUESTED_CHANGES'
);


ALTER TYPE public.approvaldecision OWNER TO postgres;

--
-- Name: approvalstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.approvalstatus AS ENUM (
    'PENDING',
    'REVIEWED',
    'APPROVED',
    'REJECTED',
    'RETURNED_FOR_REVISION'
);


ALTER TYPE public.approvalstatus OWNER TO postgres;

--
-- Name: approvaltype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.approvaltype AS ENUM (
    'TASK_COMPLETION',
    'DECISION_CONSENSUS',
    'DELIVERABLE',
    'DIRECTION_CHANGE',
    'TOOL_RESULT_VALIDATION'
);


ALTER TYPE public.approvaltype OWNER TO postgres;

--
-- Name: commenttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.commenttype AS ENUM (
    'RESPONSE',
    'CLARIFICATION',
    'DISPUTE',
    'RESOLUTION',
    'ESCALATION',
    'SYSTEM'
);


ALTER TYPE public.commenttype OWNER TO postgres;

--
-- Name: documentstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.documentstatus AS ENUM (
    'DRAFT',
    'PENDING_CONSENSUS',
    'APPROVED',
    'REJECTED',
    'SAVED',
    'SUPERSEDED'
);


ALTER TYPE public.documentstatus OWNER TO postgres;

--
-- Name: documenttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.documenttype AS ENUM (
    'TRANSCRIPT',
    'MINUTES',
    'SUMMARY',
    'AGENDA',
    'DISCUSSION_POINTS',
    'ACTION_ITEMS',
    'DECISIONS',
    'TECHNICAL_NOTE',
    'DESIGN_BASIS',
    'SPECIFICATION',
    'CALCULATION',
    'CLIENT_INPUTS_REQUIRED',
    'RFI',
    'MEETING_AGENDA',
    'CUSTOM'
);


ALTER TYPE public.documenttype OWNER TO postgres;

--
-- Name: escalation_trigger; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.escalation_trigger AS ENUM (
    'ai_review_fail_limit',
    'blocking_remark',
    'critical_remark_count',
    'manual',
    'deadline_approaching',
    'confidence_too_low'
);


ALTER TYPE public.escalation_trigger OWNER TO postgres;

--
-- Name: escalationtrigger; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.escalationtrigger AS ENUM (
    'AI_REVIEW_FAIL_LIMIT',
    'BLOCKING_REMARK',
    'CRITICAL_REMARK_COUNT',
    'MANUAL',
    'DEADLINE_APPROACHING',
    'CONFIDENCE_TOO_LOW'
);


ALTER TYPE public.escalationtrigger OWNER TO postgres;

--
-- Name: executionlogaction; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.executionlogaction AS ENUM (
    'PROJECT_CREATED',
    'PROJECT_UPDATED',
    'PROJECT_STATUS_CHANGED',
    'PM_ASSIGNED',
    'HOD_ASSIGNED',
    'TEAM_MEMBER_ASSIGNED',
    'PARTICIPANT_UNASSIGNED',
    'DISCIPLINES_DETECTED',
    'TEAM_REQUIREMENTS_DETERMINED',
    'MEETING_CREATED',
    'MEETING_STARTED',
    'MEETING_COMPLETED',
    'MEETING_FAILED',
    'AGENDA_ITEM_STARTED',
    'AGENDA_ITEM_COMPLETED',
    'TASK_CREATED',
    'TASK_STARTED',
    'TASK_COMPLETED',
    'TASK_FAILED',
    'EXECUTION_CREATED',
    'EXECUTION_STARTED',
    'EXECUTION_COMPLETED',
    'EXECUTION_FAILED',
    'TOOL_CALL_INITIATED',
    'TOOL_CALL_COMPLETED',
    'TOOL_CALL_FAILED',
    'TOOL_CALL_PENDING',
    'DECISION_PROPOSED',
    'VOTE_CAST',
    'CONSENSUS_REACHED',
    'CONSENSUS_FAILED',
    'EXECUTIVE_OVERRIDE',
    'DOCUMENT_PROPOSED',
    'DOCUMENT_APPROVED',
    'DOCUMENT_REJECTED',
    'DOCUMENT_SAVED',
    'PARTICIPANT_SPOKE',
    'CHAIR_INTERJECTION',
    'LLM_CALL',
    'ERROR_OCCURRED',
    'HOD_ANALYSIS_STARTED',
    'HOD_ANALYSIS_COMPLETED',
    'DELIVERABLES_INFERRED',
    'TEAM_TASK_CREATED',
    'TEAM_EXECUTION_STARTED',
    'TEAM_MEMBER_STARTED',
    'TEAM_MEMBER_COMPLETED',
    'TEAM_MEMBER_FAILED',
    'TEAM_EXECUTION_COMPLETED',
    'TASK_AWAITING_APPROVAL',
    'TASK_APPROVED',
    'TASK_REJECTED',
    'EXECUTION_PAUSED_HITL',
    'EXECUTION_RESUMED'
);


ALTER TYPE public.executionlogaction OWNER TO postgres;

--
-- Name: executionlogcategory; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.executionlogcategory AS ENUM (
    'PROJECT',
    'TEAM',
    'MEETING',
    'TASK',
    'TOOL',
    'DECISION',
    'DOCUMENT',
    'SYSTEM'
);


ALTER TYPE public.executionlogcategory OWNER TO postgres;

--
-- Name: executionstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.executionstatus AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'PAUSED_FOR_APPROVAL',
    'APPROVED',
    'REJECTED',
    'COMPLETED',
    'FAILED'
);


ALTER TYPE public.executionstatus OWNER TO postgres;

--
-- Name: executiontype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.executiontype AS ENUM (
    'MEETING',
    'SINGLE_AGENT',
    'HOD_TEAM_EXECUTION'
);


ALTER TYPE public.executiontype OWNER TO postgres;

--
-- Name: feedback_rating; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.feedback_rating AS ENUM (
    'thumbs_up',
    'thumbs_down'
);


ALTER TYPE public.feedback_rating OWNER TO supabase_admin;

--
-- Name: feedbackrating; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.feedbackrating AS ENUM (
    'thumbs_up',
    'thumbs_down'
);


ALTER TYPE public.feedbackrating OWNER TO postgres;

--
-- Name: meetingstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.meetingstatus AS ENUM (
    'SCHEDULED',
    'IN_PROGRESS',
    'PAUSED_FOR_DECISION',
    'CONCLUDED',
    'ARCHIVED'
);


ALTER TYPE public.meetingstatus OWNER TO postgres;

--
-- Name: prompt_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.prompt_type AS ENUM (
    'meeting_agent_response',
    'voting',
    'opening_topic',
    'speaker_selection',
    'missing_contributor',
    'verification_analysis',
    'key_input_extraction',
    'objection_categorization',
    'objection_importance',
    'action_item_extraction',
    'chat_participant',
    'chat_universal',
    'prompt_enhancement',
    'hod_analysis',
    'team_task_assignment',
    'single_agent_execution',
    'ai_review',
    'custom',
    'scope_analysis',
    'deliverable_list',
    'boq_generation',
    'soil_parameter_extraction',
    'staad_column_extraction',
    'foundation_design',
    'rcc_design',
    'civil_workflow',
    'document_analysis',
    'dbr_document_understanding',
    'dbr_data_extraction',
    'dbr_summary_generation',
    'dbr_structure',
    'dbr_section_writing'
);


ALTER TYPE public.prompt_type OWNER TO supabase_admin;

--
-- Name: prompttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.prompttype AS ENUM (
    'meeting_agent_response',
    'voting',
    'opening_topic',
    'speaker_selection',
    'missing_contributor',
    'verification_analysis',
    'key_input_extraction',
    'objection_categorization',
    'objection_importance',
    'action_item_extraction',
    'chat_participant',
    'chat_universal',
    'prompt_enhancement',
    'hod_analysis',
    'team_task_assignment',
    'single_agent_execution',
    'ai_review',
    'custom'
);


ALTER TYPE public.prompttype OWNER TO postgres;

--
-- Name: remark_severity; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.remark_severity AS ENUM (
    'info',
    'minor',
    'major',
    'critical',
    'blocking'
);


ALTER TYPE public.remark_severity OWNER TO supabase_admin;

--
-- Name: remark_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.remark_status AS ENUM (
    'open',
    'addressed',
    'accepted',
    'rejected',
    'deferred'
);


ALTER TYPE public.remark_status OWNER TO supabase_admin;

--
-- Name: remarkseverity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.remarkseverity AS ENUM (
    'INFO',
    'MINOR',
    'MAJOR',
    'CRITICAL',
    'BLOCKING'
);


ALTER TYPE public.remarkseverity OWNER TO postgres;

--
-- Name: remarkstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.remarkstatus AS ENUM (
    'OPEN',
    'ADDRESSED',
    'ACCEPTED',
    'REJECTED',
    'DEFERRED'
);


ALTER TYPE public.remarkstatus OWNER TO postgres;

--
-- Name: review_stage; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.review_stage AS ENUM (
    'draft',
    'ai_review',
    'peer_review',
    'tl_review',
    'hod_review',
    'interdept_review',
    'approved',
    'published'
);


ALTER TYPE public.review_stage OWNER TO supabase_admin;

--
-- Name: review_status; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.review_status AS ENUM (
    'in_progress',
    'passed',
    'failed',
    'escalated'
);


ALTER TYPE public.review_status OWNER TO supabase_admin;

--
-- Name: review_type; Type: TYPE; Schema: public; Owner: supabase_admin
--

CREATE TYPE public.review_type AS ENUM (
    'ai_automated',
    'human_peer',
    'human_team_lead',
    'human_hod',
    'interdepartmental',
    'external'
);


ALTER TYPE public.review_type OWNER TO supabase_admin;

--
-- Name: reviewstage; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reviewstage AS ENUM (
    'DRAFT',
    'AI_REVIEW',
    'PEER_REVIEW',
    'TL_REVIEW',
    'HOD_REVIEW',
    'INTERDEPT_REVIEW',
    'APPROVED',
    'PUBLISHED'
);


ALTER TYPE public.reviewstage OWNER TO postgres;

--
-- Name: reviewstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reviewstatus AS ENUM (
    'IN_PROGRESS',
    'PASSED',
    'FAILED',
    'ESCALATED'
);


ALTER TYPE public.reviewstatus OWNER TO postgres;

--
-- Name: reviewtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reviewtype AS ENUM (
    'AI_AUTOMATED',
    'HUMAN_PEER',
    'HUMAN_TEAM_LEAD',
    'HUMAN_HOD',
    'INTERDEPARTMENTAL',
    'EXTERNAL'
);


ALTER TYPE public.reviewtype OWNER TO postgres;

--
-- Name: senioritylevel; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.senioritylevel AS ENUM (
    'EXECUTIVE',
    'SENIOR_MANAGER',
    'MANAGER',
    'SENIOR_ENGINEER',
    'ENGINEER',
    'JUNIOR_ENGINEER'
);


ALTER TYPE public.senioritylevel OWNER TO postgres;

--
-- Name: taskrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.taskrole AS ENUM (
    'PRIMARY',
    'SUPPORTING',
    'VALIDATION'
);


ALTER TYPE public.taskrole OWNER TO postgres;

--
-- Name: taskstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.taskstatus AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'AWAITING_APPROVAL',
    'APPROVED',
    'REJECTED',
    'COMPLETED',
    'FAILED'
);


ALTER TYPE public.taskstatus OWNER TO postgres;

--
-- Name: check_stage_gate(character varying, public.review_stage); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.check_stage_gate(p_deliverable_id character varying, p_required_stage public.review_stage) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_stage review_stage;
    v_stage_order INTEGER;
    v_required_order INTEGER;
BEGIN
    -- Get current stage
    SELECT review_stage INTO v_current_stage
    FROM deliverables
    WHERE deliverable_id = p_deliverable_id;

    IF v_current_stage IS NULL THEN
        RETURN FALSE;
    END IF;

    -- Define stage order
    v_stage_order := CASE v_current_stage
        WHEN 'draft' THEN 0
        WHEN 'ai_review' THEN 1
        WHEN 'peer_review' THEN 2
        WHEN 'tl_review' THEN 3
        WHEN 'hod_review' THEN 4
        WHEN 'interdept_review' THEN 5
        WHEN 'approved' THEN 6
        WHEN 'published' THEN 7
    END;

    v_required_order := CASE p_required_stage
        WHEN 'draft' THEN 0
        WHEN 'ai_review' THEN 1
        WHEN 'peer_review' THEN 2
        WHEN 'tl_review' THEN 3
        WHEN 'hod_review' THEN 4
        WHEN 'interdept_review' THEN 5
        WHEN 'approved' THEN 6
        WHEN 'published' THEN 7
    END;

    RETURN v_stage_order >= v_required_order;
END;
$$;


ALTER FUNCTION public.check_stage_gate(p_deliverable_id character varying, p_required_stage public.review_stage) OWNER TO supabase_admin;

--
-- Name: get_next_review_stage(public.review_stage); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.get_next_review_stage(current_stage public.review_stage) RETURNS public.review_stage
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN CASE current_stage
        WHEN 'draft' THEN 'ai_review'
        WHEN 'ai_review' THEN 'peer_review'
        WHEN 'peer_review' THEN 'tl_review'
        WHEN 'tl_review' THEN 'hod_review'
        WHEN 'hod_review' THEN 'interdept_review'
        WHEN 'interdept_review' THEN 'approved'
        WHEN 'approved' THEN 'published'
        ELSE current_stage
    END;
END;
$$;


ALTER FUNCTION public.get_next_review_stage(current_stage public.review_stage) OWNER TO supabase_admin;

--
-- Name: get_user_notifications(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_notifications(p_participant_id text) RETURNS TABLE(notification_id uuid, project_id character varying, participant_id character varying, notification_message text, description text, notification_type character varying, is_read boolean, created_at timestamp with time zone, updated_at timestamp with time zone, "isActionNeeded" boolean, modal_id text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    n.notification_id,
    n.project_id,
    n.participant_id,
    n.notification_message,
    n.description,
    n.notification_type,
    n.is_read,
    n.created_at,
    n.updated_at,
    n."isActionNeeded",
    n.modal_id
  FROM notifications n
  WHERE n.participant_id = p_participant_id
  ORDER BY n.created_at DESC
  LIMIT 100;
END;
$$;


ALTER FUNCTION public.get_user_notifications(p_participant_id text) OWNER TO postgres;

--
-- Name: update_prompt_templates_updated_at(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--

CREATE FUNCTION public.update_prompt_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_prompt_templates_updated_at() OWNER TO supabase_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agenda_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agenda_items (
    agenda_item_id character varying NOT NULL,
    meeting_id character varying,
    sequence integer,
    topic character varying NOT NULL,
    expected_output text,
    initial_speaker_id character varying,
    opening_prompt text,
    status character varying,
    verification_score double precision,
    verification_details json,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.agenda_items OWNER TO postgres;

--
-- Name: approval_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_requests (
    approval_id character varying NOT NULL,
    execution_id character varying,
    task_id character varying,
    deliverable_id character varying,
    review_id character varying,
    approval_type public.approvaltype NOT NULL,
    status public.approvalstatus,
    priority character varying(20),
    requested_by character varying,
    content_to_approve json,
    approval_context json,
    assigned_to character varying,
    deadline timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.approval_requests OWNER TO postgres;

--
-- Name: TABLE approval_requests; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.approval_requests IS 'Requests awaiting human review/approval for tasks, deliverables, decisions, or direction changes.';


--
-- Name: approvals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approvals (
    approval_record_id character varying NOT NULL,
    approval_id character varying NOT NULL,
    approver_id character varying,
    approver_role character varying(100),
    decision public.approvaldecision NOT NULL,
    comments text,
    change_requests json,
    signature_token character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.approvals OWNER TO postgres;

--
-- Name: TABLE approvals; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.approvals IS 'Records of approval decisions with comments, change requests, and audit trail.';


--
-- Name: boq_weights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boq_weights (
    id integer NOT NULL,
    designation character varying(100) NOT NULL,
    height_mm numeric(8,2) NOT NULL,
    flange_width_mm numeric(8,2) NOT NULL,
    web_thickness_mm numeric(6,2) NOT NULL,
    flange_thickness_mm numeric(6,2) NOT NULL,
    weight_kg_per_m numeric(8,2) NOT NULL,
    standard character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.boq_weights OWNER TO postgres;

--
-- Name: boq_weights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boq_weights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boq_weights_id_seq OWNER TO postgres;

--
-- Name: boq_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boq_weights_id_seq OWNED BY public.boq_weights.id;


--
-- Name: deliverable_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliverable_documents (
    link_id character varying NOT NULL,
    deliverable_id character varying NOT NULL,
    document_id character varying NOT NULL,
    link_type character varying(50),
    document_name character varying(500),
    document_type character varying(100),
    mime_type character varying(100),
    file_size_bytes integer,
    storage_path character varying,
    version_label character varying(50),
    is_current boolean,
    is_public boolean,
    access_roles json,
    content_extracted boolean,
    extracted_content_path character varying,
    extraction_status character varying(50),
    extraction_error text,
    linked_by character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.deliverable_documents OWNER TO postgres;

--
-- Name: deliverable_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliverable_reviews (
    review_id character varying NOT NULL,
    deliverable_id character varying NOT NULL,
    version_id character varying,
    review_type public.reviewtype NOT NULL,
    reviewer_type character varying(50),
    reviewer_id character varying,
    reviewer_discipline character varying(50),
    checklist_id character varying,
    pass_number integer,
    status public.reviewstatus,
    overall_confidence double precision,
    remarks json,
    checklist_results json,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.deliverable_reviews OWNER TO postgres;

--
-- Name: TABLE deliverable_reviews; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.deliverable_reviews IS 'Tracks each review pass on a deliverable (AI, peer, TL, HOD, interdepartmental, external).';


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.deliverables (
    deliverable_id character varying NOT NULL,
    project_id character varying NOT NULL,
    execution_id character varying,
    title character varying(500) NOT NULL,
    description text,
    expected_output text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    assigned_to_participant_id character varying,
    task_id character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    due_date timestamp without time zone,
    completed_at timestamp without time zone,
    created_by_participant_id character varying,
    deliverable_metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    review_stage public.review_stage DEFAULT 'draft'::public.review_stage,
    assigned_checklist_ids jsonb,
    last_ai_review_passed boolean DEFAULT false,
    total_review_passes integer DEFAULT 0,
    ai_review_fail_count integer DEFAULT 0,
    auto_escalation_enabled boolean DEFAULT true,
    last_escalation_at timestamp without time zone,
    last_escalation_trigger public.escalation_trigger,
    workflow_config_id character varying
);


ALTER TABLE public.deliverables OWNER TO supabase_admin;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    project_id character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    client_name character varying,
    contract_reference character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    status character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    team_assignment_confirmed_at timestamp without time zone,
    hod_assignment_confirmed boolean DEFAULT false,
    hod_assignment_confirmed_at timestamp with time zone,
    kickoff_prep_meeting_id text,
    team_assignment_confirmed text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: COLUMN projects.team_assignment_confirmed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.projects.team_assignment_confirmed_at IS 'Timestamp when the team assignment was confirmed';


--
-- Name: COLUMN projects.hod_assignment_confirmed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.projects.hod_assignment_confirmed IS 'Indicates whether HOD assignments have been confirmed for this project';


--
-- Name: COLUMN projects.hod_assignment_confirmed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.projects.hod_assignment_confirmed_at IS 'Timestamp when HOD assignments were confirmed';


--
-- Name: review_remarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_remarks (
    remark_id character varying NOT NULL,
    review_id character varying NOT NULL,
    checklist_item_id character varying,
    category character varying(50),
    severity public.remarkseverity NOT NULL,
    description text NOT NULL,
    location_reference character varying,
    confidence_score double precision,
    source_references json,
    suggested_resolution text,
    status public.remarkstatus,
    resolution text,
    resolved_by character varying,
    resolved_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.review_remarks OWNER TO postgres;

--
-- Name: TABLE review_remarks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.review_remarks IS 'Individual remarks from reviews with severity levels and resolution tracking.';


--
-- Name: deliverable_review_summary; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.deliverable_review_summary AS
 SELECT d.deliverable_id,
    d.title,
    d.review_stage,
    d.total_review_passes,
    d.last_ai_review_passed,
    p.project_id,
    p.name AS project_name,
    ( SELECT count(*) AS count
           FROM (public.review_remarks rr
             JOIN public.deliverable_reviews dr ON (((rr.review_id)::text = (dr.review_id)::text)))
          WHERE (((dr.deliverable_id)::text = (d.deliverable_id)::text) AND ((rr.status)::text = 'open'::text))) AS open_remarks_count,
    ( SELECT count(*) AS count
           FROM (public.review_remarks rr
             JOIN public.deliverable_reviews dr ON (((rr.review_id)::text = (dr.review_id)::text)))
          WHERE (((dr.deliverable_id)::text = (d.deliverable_id)::text) AND ((rr.status)::text = 'open'::text) AND ((rr.severity)::text = ANY (ARRAY['critical'::text, 'blocking'::text])))) AS blocking_remarks_count,
    ( SELECT max(dr.completed_at) AS max
           FROM public.deliverable_reviews dr
          WHERE ((dr.deliverable_id)::text = (d.deliverable_id)::text)) AS last_review_date
   FROM (public.deliverables d
     JOIN public.projects p ON (((d.project_id)::text = (p.project_id)::text)));


ALTER TABLE public.deliverable_review_summary OWNER TO supabase_admin;

--
-- Name: deliverable_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliverable_tasks (
    deliverable_task_id character varying NOT NULL,
    deliverable_id character varying NOT NULL,
    task_id character varying NOT NULL,
    is_primary boolean,
    sequence_order integer,
    contribution_description text,
    created_at timestamp without time zone
);


ALTER TABLE public.deliverable_tasks OWNER TO postgres;

--
-- Name: deliverable_versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliverable_versions (
    version_id character varying NOT NULL,
    deliverable_id character varying NOT NULL,
    version_number integer NOT NULL,
    change_description text,
    content_hash character varying(64),
    file_path character varying,
    created_by character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.deliverable_versions OWNER TO postgres;

--
-- Name: TABLE deliverable_versions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.deliverable_versions IS 'Version control for deliverables. Each revision creates a new version for tracking change history.';


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id character varying NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: designations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designations (
    designation_id character varying NOT NULL,
    title character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    level integer,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "ROLE" text
);


ALTER TABLE public.designations OWNER TO postgres;

--
-- Name: document_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.document_types OWNER TO postgres;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.documents (
    document_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id text NOT NULL,
    name text NOT NULL,
    filetype text,
    raw_storage_endpoint text,
    parsed_storage_endpoint text,
    version double precision DEFAULT 1,
    department text,
    created_at timestamp with time zone DEFAULT now(),
    doc_type text,
    is_deliverable boolean DEFAULT false
);


ALTER TABLE public.documents OWNER TO supabase_admin;

--
-- Name: escalation_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escalation_events (
    event_id character varying NOT NULL,
    deliverable_id character varying NOT NULL,
    review_id character varying,
    trigger public.escalationtrigger NOT NULL,
    from_stage public.reviewstage NOT NULL,
    to_stage public.reviewstage NOT NULL,
    escalated_to_participant_id character varying,
    escalation_level character varying(20),
    trigger_details json,
    triggered_by character varying(50) NOT NULL,
    is_automatic boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.escalation_events OWNER TO postgres;

--
-- Name: execution_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_logs (
    log_id character varying NOT NULL,
    parent_log_id character varying,
    sequence integer,
    category public.executionlogcategory NOT NULL,
    action public.executionlogaction NOT NULL,
    project_id character varying,
    execution_id character varying,
    meeting_id character varying,
    task_id character varying,
    tool_call_id character varying,
    entity_type character varying(50),
    entity_id character varying,
    actor_type character varying(50),
    actor_id character varying,
    actor_name character varying(200),
    title character varying(500) NOT NULL,
    description text,
    status character varying(50),
    log_metadata json,
    "timestamp" timestamp without time zone,
    duration_ms integer,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    error_message text,
    error_type character varying(100)
);


ALTER TABLE public.execution_logs OWNER TO postgres;

--
-- Name: execution_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_sessions (
    execution_id character varying NOT NULL,
    execution_type public.executiontype NOT NULL,
    project_id character varying,
    agent_name character varying,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status public.executionstatus,
    config_json json,
    project_context text,
    created_at timestamp without time zone,
    parent_execution_id character varying,
    hod_participant_id character varying,
    discipline character varying(50),
    paused_for_hitl boolean DEFAULT false,
    pending_approval_task_ids jsonb
);


ALTER TABLE public.execution_sessions OWNER TO postgres;

--
-- Name: global_chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.global_chat_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    role character varying(50) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    document_urls text[],
    thinking_events jsonb,
    CONSTRAINT global_chat_messages_role_check CHECK (((role)::text = ANY ((ARRAY['user'::character varying, 'assistant'::character varying])::text[])))
);


ALTER TABLE public.global_chat_messages OWNER TO postgres;

--
-- Name: global_chat_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.global_chat_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    participant_id character varying(255) NOT NULL,
    project_id character varying(255),
    title character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.global_chat_sessions OWNER TO postgres;

--
-- Name: meeting_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeting_documents (
    document_id character varying NOT NULL,
    meeting_id character varying,
    execution_id character varying,
    project_id character varying,
    agenda_item_id character varying,
    title character varying(500) NOT NULL,
    document_type public.documenttype NOT NULL,
    status public.documentstatus,
    version integer,
    content text NOT NULL,
    content_format character varying(20),
    storage_path character varying(1000),
    file_size_bytes integer,
    generated_by character varying(100),
    generation_context json,
    tags json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.meeting_documents OWNER TO postgres;

--
-- Name: meetings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meetings (
    meeting_id character varying NOT NULL,
    execution_id character varying,
    title character varying NOT NULL,
    description text,
    project_id character varying,
    chair_id character varying,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    duration_minutes integer,
    status public.meetingstatus,
    current_topic character varying,
    created_at timestamp without time zone,
    sse_url character varying
);


ALTER TABLE public.meetings OWNER TO postgres;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id character varying NOT NULL,
    participant_id character varying NOT NULL,
    notification_message text NOT NULL,
    description text NOT NULL,
    notification_type character varying(50) NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    "isActionNeeded" boolean DEFAULT false,
    modal_id text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: participant_project_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participant_project_assignments (
    assignment_id character varying NOT NULL,
    participant_id character varying NOT NULL,
    project_id character varying NOT NULL,
    assigned_at timestamp without time zone,
    role_in_project character varying,
    is_active boolean
);


ALTER TABLE public.participant_project_assignments OWNER TO postgres;

--
-- Name: participant_tool_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participant_tool_assignments (
    assignment_id character varying NOT NULL,
    participant_id character varying NOT NULL,
    tool_id character varying,
    source_group_id character varying,
    assignment_type character varying(20) NOT NULL,
    is_active boolean,
    assigned_at timestamp without time zone,
    assigned_by character varying(100),
    reason text
);


ALTER TABLE public.participant_tool_assignments OWNER TO postgres;

--
-- Name: participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participants (
    participant_id character varying NOT NULL,
    participant_key character varying NOT NULL,
    name character varying NOT NULL,
    discipline character varying(50),
    designation character varying(100),
    is_hod boolean,
    expertise json,
    personality text,
    seniority_level public.senioritylevel,
    linkedin_profile json,
    tools_assigned json,
    can_override_consensus boolean,
    speaking_weight double precision,
    use_db_tool_assignments boolean,
    default_tool_group_id character varying,
    department_id character varying,
    designation_id character varying,
    created_at timestamp without time zone,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    user_id uuid,
    tool_config jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.participants OWNER TO postgres;

--
-- Name: COLUMN participants.tool_config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.participants.tool_config IS 'Tool configuration JSON: {"assigned_tool_group": "CIVIL_TOOLS", "other_tools": ["tool1", "tool2"]}';


--
-- Name: pending_approvals_view; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.pending_approvals_view AS
 SELECT ar.approval_id,
    ar.approval_type,
    ar.priority,
    ar.deadline,
    ar.created_at,
    ar.content_to_approve,
    ar.approval_context,
    d.deliverable_id,
    d.title AS deliverable_title,
    d.review_stage,
    p_req.name AS requested_by_name,
    p_req.participant_key AS requested_by_key,
    p_assign.name AS assigned_to_name,
    p_assign.participant_key AS assigned_to_key,
    p_assign.discipline AS assigned_to_discipline
   FROM (((public.approval_requests ar
     LEFT JOIN public.deliverables d ON (((ar.deliverable_id)::text = (d.deliverable_id)::text)))
     LEFT JOIN public.participants p_req ON (((ar.requested_by)::text = (p_req.participant_id)::text)))
     LEFT JOIN public.participants p_assign ON (((ar.assigned_to)::text = (p_assign.participant_id)::text)))
  WHERE ((ar.status)::text = 'pending'::text)
  ORDER BY
        CASE ar.priority
            WHEN 'critical'::text THEN 1
            WHEN 'high'::text THEN 2
            WHEN 'medium'::text THEN 3
            WHEN 'low'::text THEN 4
            ELSE NULL::integer
        END, ar.created_at;


ALTER TABLE public.pending_approvals_view OWNER TO supabase_admin;

--
-- Name: project_chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_chat_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    role character varying(50) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT project_chat_messages_role_check CHECK (((role)::text = ANY ((ARRAY['user'::character varying, 'assistant'::character varying])::text[])))
);


ALTER TABLE public.project_chat_messages OWNER TO postgres;

--
-- Name: project_chat_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_chat_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    participant_id character varying(255) NOT NULL,
    project_id character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.project_chat_sessions OWNER TO postgres;

--
-- Name: prompt_feedback; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.prompt_feedback (
    feedback_id character varying NOT NULL,
    invocation_id character varying NOT NULL,
    rating public.feedback_rating NOT NULL,
    comment text,
    feedback_category character varying(50),
    feedback_by character varying,
    feedback_by_external character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.prompt_feedback OWNER TO supabase_admin;

--
-- Name: TABLE prompt_feedback; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.prompt_feedback IS 'User feedback (thumbs up/down + optional comment) on prompt invocations for continuous improvement.';


--
-- Name: prompt_invocations; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.prompt_invocations (
    invocation_id character varying NOT NULL,
    template_id character varying,
    template_version integer,
    prompt_type public.prompt_type NOT NULL,
    execution_id character varying,
    task_id character varying,
    meeting_id character varying,
    project_id character varying,
    participant_id character varying,
    system_prompt text,
    user_prompt text,
    prompt_hash character varying(64),
    template_variables_used jsonb,
    model_name character varying(100),
    temperature double precision,
    max_tokens integer,
    response_text text,
    response_truncated boolean DEFAULT false,
    input_tokens integer,
    output_tokens integer,
    tools_available jsonb,
    tools_used jsonb,
    duration_ms integer,
    success boolean DEFAULT true,
    error_message text,
    session_id character varying,
    sequence_in_session integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.prompt_invocations OWNER TO supabase_admin;

--
-- Name: TABLE prompt_invocations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.prompt_invocations IS 'Log of every prompt sent to LLM. Links to template and captures actual rendered content for traceability.';


--
-- Name: prompt_templates; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.prompt_templates (
    template_id character varying NOT NULL,
    prompt_type public.prompt_type NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    system_template text,
    user_template text,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    previous_version_id character varying,
    template_variables jsonb,
    expected_output_format character varying(50),
    created_by character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    place_of_use text DEFAULT 'core'::text
);


ALTER TABLE public.prompt_templates OWNER TO supabase_admin;

--
-- Name: TABLE prompt_templates; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON TABLE public.prompt_templates IS 'Versioned prompt templates - source of truth for all system prompts. Only one active version per prompt_type+name.';


--
-- Name: COLUMN prompt_templates.place_of_use; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public.prompt_templates.place_of_use IS 'can be core, tools';


--
-- Name: prompt_feedback_summary; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.prompt_feedback_summary AS
 SELECT pt.prompt_type,
    pt.name AS template_name,
    pt.version AS template_version,
    count(DISTINCT pi.invocation_id) AS total_invocations,
    count(DISTINCT pf.feedback_id) AS total_feedback,
    count(DISTINCT
        CASE
            WHEN (pf.rating = 'thumbs_up'::public.feedback_rating) THEN pf.feedback_id
            ELSE NULL::character varying
        END) AS thumbs_up_count,
    count(DISTINCT
        CASE
            WHEN (pf.rating = 'thumbs_down'::public.feedback_rating) THEN pf.feedback_id
            ELSE NULL::character varying
        END) AS thumbs_down_count,
        CASE
            WHEN (count(DISTINCT pf.feedback_id) > 0) THEN round((((count(DISTINCT
            CASE
                WHEN (pf.rating = 'thumbs_up'::public.feedback_rating) THEN pf.feedback_id
                ELSE NULL::character varying
            END))::numeric / (count(DISTINCT pf.feedback_id))::numeric) * (100)::numeric), 2)
            ELSE NULL::numeric
        END AS approval_rate_percent
   FROM ((public.prompt_templates pt
     LEFT JOIN public.prompt_invocations pi ON (((pt.template_id)::text = (pi.template_id)::text)))
     LEFT JOIN public.prompt_feedback pf ON (((pi.invocation_id)::text = (pf.invocation_id)::text)))
  WHERE (pt.is_active = true)
  GROUP BY pt.prompt_type, pt.name, pt.version
  ORDER BY pt.prompt_type, pt.name;


ALTER TABLE public.prompt_feedback_summary OWNER TO supabase_admin;

--
-- Name: VIEW prompt_feedback_summary; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON VIEW public.prompt_feedback_summary IS 'Aggregated feedback statistics per active prompt template.';


--
-- Name: recent_prompt_invocations; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.recent_prompt_invocations AS
 SELECT pi.invocation_id,
    pi.prompt_type,
    pt.name AS template_name,
    pi.model_name,
    pi.input_tokens,
    pi.output_tokens,
    pi.duration_ms,
    pi.success,
    pi.session_id,
    pi.created_at,
    count(pf.feedback_id) AS feedback_count,
    max(
        CASE
            WHEN (pf.rating = 'thumbs_up'::public.feedback_rating) THEN 1
            ELSE 0
        END) AS has_thumbs_up,
    max(
        CASE
            WHEN (pf.rating = 'thumbs_down'::public.feedback_rating) THEN 1
            ELSE 0
        END) AS has_thumbs_down
   FROM ((public.prompt_invocations pi
     LEFT JOIN public.prompt_templates pt ON (((pi.template_id)::text = (pt.template_id)::text)))
     LEFT JOIN public.prompt_feedback pf ON (((pi.invocation_id)::text = (pf.invocation_id)::text)))
  GROUP BY pi.invocation_id, pi.prompt_type, pt.name, pi.model_name, pi.input_tokens, pi.output_tokens, pi.duration_ms, pi.success, pi.session_id, pi.created_at
  ORDER BY pi.created_at DESC;


ALTER TABLE public.recent_prompt_invocations OWNER TO supabase_admin;

--
-- Name: VIEW recent_prompt_invocations; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON VIEW public.recent_prompt_invocations IS 'Recent prompt invocations with feedback counts for monitoring.';


--
-- Name: remark_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.remark_comments (
    comment_id character varying NOT NULL,
    remark_id character varying NOT NULL,
    comment_type public.commenttype NOT NULL,
    content text NOT NULL,
    parent_comment_id character varying,
    thread_depth integer,
    author_id character varying,
    author_role character varying(50),
    is_edited boolean,
    edited_at timestamp without time zone,
    attachments json,
    notified_participants json,
    created_at timestamp without time zone
);


ALTER TABLE public.remark_comments OWNER TO postgres;

--
-- Name: review_checklists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_checklists (
    checklist_id character varying NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    discipline character varying(50),
    deliverable_type character varying(100),
    checklist_items json NOT NULL,
    version integer,
    is_active boolean,
    created_by character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.review_checklists OWNER TO postgres;

--
-- Name: TABLE review_checklists; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.review_checklists IS 'Checklists that deliverables must pass before advancing stages. Associated with disciplines and deliverable types.';


--
-- Name: review_workflow_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_workflow_configs (
    config_id character varying NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    project_id character varying,
    discipline character varying(50),
    deliverable_type character varying(100),
    required_stages json NOT NULL,
    max_ai_review_attempts integer,
    escalate_on_blocking_remark boolean,
    escalate_on_critical_count integer,
    escalate_to_on_ai_fail character varying(20),
    min_confidence_threshold double precision,
    skip_peer_if_ai_confidence_above double precision,
    skip_tl_for_low_priority boolean,
    skip_hod_for_low_priority boolean,
    notify_on_escalation boolean,
    notify_hod_on_blocking boolean,
    escalate_hours_before_deadline integer,
    escalate_if_no_review_days integer,
    escalation_cooldown_hours integer,
    max_escalation_level character varying(20),
    escalate_on_stale_remarks_days integer,
    is_active boolean,
    is_default boolean,
    created_by character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.review_workflow_configs OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    task_id character varying NOT NULL,
    execution_id character varying,
    task_sequence integer,
    title character varying NOT NULL,
    description text,
    expected_output text,
    status public.taskstatus,
    agent_assigned character varying,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    result_content text,
    error_message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    assigned_by_participant_id character varying,
    parent_task_id character varying,
    deliverable_reference character varying,
    project_id text,
    assigned_to_participant_id character varying,
    priority character varying(20) DEFAULT 'medium'::character varying,
    suggested_tools jsonb,
    context_data jsonb,
    due_date timestamp without time zone,
    complexity character varying(20),
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    requires_approval boolean DEFAULT false,
    approval_criteria jsonb,
    approved_by character varying,
    approved_at timestamp without time zone,
    approval_feedback text,
    rejection_reason text,
    depends_on_task_id character varying
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tool_assignment_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_assignment_audit (
    audit_id character varying NOT NULL,
    participant_id character varying,
    tool_id character varying,
    group_id character varying,
    action character varying(50) NOT NULL,
    performed_by character varying(100),
    performed_at timestamp without time zone,
    old_value json,
    new_value json,
    reason text
);


ALTER TABLE public.tool_assignment_audit OWNER TO postgres;

--
-- Name: tool_calls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_calls (
    tool_call_id character varying NOT NULL,
    execution_id character varying,
    task_id character varying,
    agent_name character varying,
    tool_name character varying,
    tool_args json,
    call_sequence integer,
    status character varying,
    initiated_at timestamp without time zone,
    completed_at timestamp without time zone,
    wait_interval_used integer,
    created_at timestamp without time zone
);


ALTER TABLE public.tool_calls OWNER TO postgres;

--
-- Name: tool_group_memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_group_memberships (
    membership_id character varying NOT NULL,
    group_id character varying NOT NULL,
    tool_id character varying NOT NULL,
    added_at timestamp without time zone,
    added_by character varying(100)
);


ALTER TABLE public.tool_group_memberships OWNER TO postgres;

--
-- Name: tool_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_groups (
    group_id character varying NOT NULL,
    name character varying(100) NOT NULL,
    display_name character varying(200),
    description text,
    discipline character varying(100),
    includes_base_tools boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.tool_groups OWNER TO postgres;

--
-- Name: tool_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_results (
    tool_result_id character varying NOT NULL,
    tool_call_id character varying,
    result_content text,
    result_status character varying,
    error_message text,
    validation_status character varying,
    approver_notes text,
    received_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.tool_results OWNER TO postgres;

--
-- Name: tools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools (
    tool_id character varying NOT NULL,
    name character varying(100) NOT NULL,
    display_name character varying(200),
    description text,
    category character varying(100),
    is_base_tool boolean,
    is_chair_only boolean,
    parameters_schema json,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tool_group_id character varying
);


ALTER TABLE public.tools OWNER TO postgres;

--
-- Name: transcript_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transcript_entries (
    transcript_entry_id character varying NOT NULL,
    execution_id character varying,
    meeting_id character varying,
    task_id character varying,
    message_type character varying,
    agent_name character varying,
    content text,
    entry_metadata json,
    sequence integer,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.transcript_entries OWNER TO postgres;

--
-- Name: boq_weights id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boq_weights ALTER COLUMN id SET DEFAULT nextval('public.boq_weights_id_seq'::regclass);


--
-- Name: agenda_items agenda_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agenda_items
    ADD CONSTRAINT agenda_items_pkey PRIMARY KEY (agenda_item_id);


--
-- Name: approval_requests approval_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_pkey PRIMARY KEY (approval_id);


--
-- Name: approvals approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approvals
    ADD CONSTRAINT approvals_pkey PRIMARY KEY (approval_record_id);


--
-- Name: boq_weights boq_weights_designation_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boq_weights
    ADD CONSTRAINT boq_weights_designation_key UNIQUE (designation);


--
-- Name: boq_weights boq_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boq_weights
    ADD CONSTRAINT boq_weights_pkey PRIMARY KEY (id);


--
-- Name: deliverable_documents deliverable_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_documents
    ADD CONSTRAINT deliverable_documents_pkey PRIMARY KEY (link_id);


--
-- Name: deliverable_reviews deliverable_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_reviews
    ADD CONSTRAINT deliverable_reviews_pkey PRIMARY KEY (review_id);


--
-- Name: deliverable_tasks deliverable_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_tasks
    ADD CONSTRAINT deliverable_tasks_pkey PRIMARY KEY (deliverable_task_id);


--
-- Name: deliverable_versions deliverable_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_versions
    ADD CONSTRAINT deliverable_versions_pkey PRIMARY KEY (version_id);


--
-- Name: deliverables deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_pkey PRIMARY KEY (deliverable_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (designation_id);


--
-- Name: document_types document_types_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT document_types_code_key UNIQUE (code);


--
-- Name: document_types document_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT document_types_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (document_id);


--
-- Name: escalation_events escalation_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalation_events
    ADD CONSTRAINT escalation_events_pkey PRIMARY KEY (event_id);


--
-- Name: execution_logs execution_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_pkey PRIMARY KEY (log_id);


--
-- Name: execution_sessions execution_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_sessions
    ADD CONSTRAINT execution_sessions_pkey PRIMARY KEY (execution_id);


--
-- Name: global_chat_messages global_chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.global_chat_messages
    ADD CONSTRAINT global_chat_messages_pkey PRIMARY KEY (id);


--
-- Name: global_chat_sessions global_chat_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.global_chat_sessions
    ADD CONSTRAINT global_chat_sessions_pkey PRIMARY KEY (id);


--
-- Name: meeting_documents meeting_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_documents
    ADD CONSTRAINT meeting_documents_pkey PRIMARY KEY (document_id);


--
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (meeting_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: participant_project_assignments participant_project_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_project_assignments
    ADD CONSTRAINT participant_project_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: participant_tool_assignments participant_tool_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_tool_assignments
    ADD CONSTRAINT participant_tool_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: participants participants_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_email_key UNIQUE (email);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (participant_id);


--
-- Name: project_chat_messages project_chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_chat_messages
    ADD CONSTRAINT project_chat_messages_pkey PRIMARY KEY (id);


--
-- Name: project_chat_sessions project_chat_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_chat_sessions
    ADD CONSTRAINT project_chat_sessions_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- Name: prompt_feedback prompt_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_feedback
    ADD CONSTRAINT prompt_feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: prompt_invocations prompt_invocations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_pkey PRIMARY KEY (invocation_id);


--
-- Name: prompt_templates prompt_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_pkey PRIMARY KEY (template_id);


--
-- Name: remark_comments remark_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remark_comments
    ADD CONSTRAINT remark_comments_pkey PRIMARY KEY (comment_id);


--
-- Name: review_checklists review_checklists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_checklists
    ADD CONSTRAINT review_checklists_pkey PRIMARY KEY (checklist_id);


--
-- Name: review_remarks review_remarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_remarks
    ADD CONSTRAINT review_remarks_pkey PRIMARY KEY (remark_id);


--
-- Name: review_workflow_configs review_workflow_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_workflow_configs
    ADD CONSTRAINT review_workflow_configs_pkey PRIMARY KEY (config_id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);


--
-- Name: tool_assignment_audit tool_assignment_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_assignment_audit
    ADD CONSTRAINT tool_assignment_audit_pkey PRIMARY KEY (audit_id);


--
-- Name: tool_calls tool_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_calls
    ADD CONSTRAINT tool_calls_pkey PRIMARY KEY (tool_call_id);


--
-- Name: tool_group_memberships tool_group_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_group_memberships
    ADD CONSTRAINT tool_group_memberships_pkey PRIMARY KEY (membership_id);


--
-- Name: tool_groups tool_groups_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_groups
    ADD CONSTRAINT tool_groups_name_key UNIQUE (name);


--
-- Name: tool_groups tool_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_groups
    ADD CONSTRAINT tool_groups_pkey PRIMARY KEY (group_id);


--
-- Name: tool_results tool_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_results
    ADD CONSTRAINT tool_results_pkey PRIMARY KEY (tool_result_id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);


--
-- Name: transcript_entries transcript_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_entries
    ADD CONSTRAINT transcript_entries_pkey PRIMARY KEY (transcript_entry_id);


--
-- Name: idx_approval_requests_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_assigned_to ON public.approval_requests USING btree (assigned_to);


--
-- Name: idx_approval_requests_deliverable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_deliverable_id ON public.approval_requests USING btree (deliverable_id);


--
-- Name: idx_approval_requests_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_execution_id ON public.approval_requests USING btree (execution_id);


--
-- Name: idx_approval_requests_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_priority ON public.approval_requests USING btree (priority);


--
-- Name: idx_approval_requests_requested_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_requested_by ON public.approval_requests USING btree (requested_by);


--
-- Name: idx_approval_requests_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approval_requests_status ON public.approval_requests USING btree (status);


--
-- Name: idx_approvals_approval_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approvals_approval_id ON public.approvals USING btree (approval_id);


--
-- Name: idx_approvals_approver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approvals_approver_id ON public.approvals USING btree (approver_id);


--
-- Name: idx_approvals_decision; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_approvals_decision ON public.approvals USING btree (decision);


--
-- Name: idx_boq_weights_designation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boq_weights_designation ON public.boq_weights USING btree (designation);


--
-- Name: idx_boq_weights_height; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boq_weights_height ON public.boq_weights USING btree (height_mm);


--
-- Name: idx_boq_weights_standard; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boq_weights_standard ON public.boq_weights USING btree (standard);


--
-- Name: idx_boq_weights_weight; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boq_weights_weight ON public.boq_weights USING btree (weight_kg_per_m);


--
-- Name: idx_deliverable_documents_deliverable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_documents_deliverable_id ON public.deliverable_documents USING btree (deliverable_id);


--
-- Name: idx_deliverable_documents_document_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_documents_document_id ON public.deliverable_documents USING btree (document_id);


--
-- Name: idx_deliverable_documents_link_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_documents_link_type ON public.deliverable_documents USING btree (link_type);


--
-- Name: idx_deliverable_reviews_deliverable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_reviews_deliverable_id ON public.deliverable_reviews USING btree (deliverable_id);


--
-- Name: idx_deliverable_reviews_review_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_reviews_review_type ON public.deliverable_reviews USING btree (review_type);


--
-- Name: idx_deliverable_reviews_reviewer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_reviews_reviewer_id ON public.deliverable_reviews USING btree (reviewer_id);


--
-- Name: idx_deliverable_reviews_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_reviews_status ON public.deliverable_reviews USING btree (status);


--
-- Name: idx_deliverable_tasks_deliverable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_tasks_deliverable_id ON public.deliverable_tasks USING btree (deliverable_id);


--
-- Name: idx_deliverable_tasks_is_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_tasks_is_primary ON public.deliverable_tasks USING btree (is_primary);


--
-- Name: idx_deliverable_tasks_task_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_tasks_task_id ON public.deliverable_tasks USING btree (task_id);


--
-- Name: idx_deliverable_versions_deliverable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliverable_versions_deliverable_id ON public.deliverable_versions USING btree (deliverable_id);


--
-- Name: idx_deliverable_versions_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_deliverable_versions_unique ON public.deliverable_versions USING btree (deliverable_id, version_number);


--
-- Name: idx_deliverables_execution_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_deliverables_execution_id ON public.deliverables USING btree (execution_id);


--
-- Name: idx_deliverables_project_id; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_deliverables_project_id ON public.deliverables USING btree (project_id);


--
-- Name: idx_deliverables_review_stage; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_deliverables_review_stage ON public.deliverables USING btree (review_stage);


--
-- Name: idx_deliverables_status; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_deliverables_status ON public.deliverables USING btree (status);


--
-- Name: idx_deliverables_workflow_config; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_deliverables_workflow_config ON public.deliverables USING btree (workflow_config_id);


--
-- Name: idx_escalation_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalation_created_at ON public.escalation_events USING btree (created_at);


--
-- Name: idx_escalation_deliverable; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalation_deliverable ON public.escalation_events USING btree (deliverable_id);


--
-- Name: idx_escalation_trigger; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_escalation_trigger ON public.escalation_events USING btree (trigger);


--
-- Name: idx_global_chat_messages_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_global_chat_messages_session ON public.global_chat_messages USING btree (session_id);


--
-- Name: idx_global_chat_sessions_participant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_global_chat_sessions_participant ON public.global_chat_sessions USING btree (participant_id);


--
-- Name: idx_global_chat_sessions_participant_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_global_chat_sessions_participant_project ON public.global_chat_sessions USING btree (participant_id, project_id);


--
-- Name: idx_global_chat_sessions_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_global_chat_sessions_project ON public.global_chat_sessions USING btree (project_id);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_participant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_participant_id ON public.notifications USING btree (participant_id);


--
-- Name: idx_notifications_participant_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_participant_read ON public.notifications USING btree (participant_id, is_read);


--
-- Name: idx_notifications_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_project_id ON public.notifications USING btree (project_id);


--
-- Name: idx_participants_tool_config_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_participants_tool_config_group ON public.participants USING btree (((tool_config ->> 'assigned_tool_group'::text))) WHERE ((tool_config ->> 'assigned_tool_group'::text) IS NOT NULL);


--
-- Name: idx_participants_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_participants_user_id ON public.participants USING btree (user_id);


--
-- Name: idx_project_chat_messages_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_chat_messages_session ON public.project_chat_messages USING btree (session_id);


--
-- Name: idx_project_chat_sessions_participant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_chat_sessions_participant ON public.project_chat_sessions USING btree (participant_id);


--
-- Name: idx_project_chat_sessions_participant_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_chat_sessions_participant_project ON public.project_chat_sessions USING btree (participant_id, project_id);


--
-- Name: idx_project_chat_sessions_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_project_chat_sessions_project ON public.project_chat_sessions USING btree (project_id);


--
-- Name: idx_prompt_feedback_created_at; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_feedback_created_at ON public.prompt_feedback USING btree (created_at);


--
-- Name: idx_prompt_feedback_invocation; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_feedback_invocation ON public.prompt_feedback USING btree (invocation_id);


--
-- Name: idx_prompt_feedback_rating; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_feedback_rating ON public.prompt_feedback USING btree (rating);


--
-- Name: idx_prompt_invocations_created_at; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_created_at ON public.prompt_invocations USING btree (created_at);


--
-- Name: idx_prompt_invocations_execution; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_execution ON public.prompt_invocations USING btree (execution_id);


--
-- Name: idx_prompt_invocations_hash; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_hash ON public.prompt_invocations USING btree (prompt_hash);


--
-- Name: idx_prompt_invocations_participant; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_participant ON public.prompt_invocations USING btree (participant_id);


--
-- Name: idx_prompt_invocations_project; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_project ON public.prompt_invocations USING btree (project_id);


--
-- Name: idx_prompt_invocations_session; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_session ON public.prompt_invocations USING btree (session_id);


--
-- Name: idx_prompt_invocations_template; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_template ON public.prompt_invocations USING btree (template_id);


--
-- Name: idx_prompt_invocations_type; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_invocations_type ON public.prompt_invocations USING btree (prompt_type);


--
-- Name: idx_prompt_templates_active; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_templates_active ON public.prompt_templates USING btree (is_active);


--
-- Name: idx_prompt_templates_active_unique; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE UNIQUE INDEX idx_prompt_templates_active_unique ON public.prompt_templates USING btree (prompt_type, name) WHERE (is_active = true);


--
-- Name: idx_prompt_templates_type; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_templates_type ON public.prompt_templates USING btree (prompt_type);


--
-- Name: idx_prompt_templates_type_name; Type: INDEX; Schema: public; Owner: supabase_admin
--

CREATE INDEX idx_prompt_templates_type_name ON public.prompt_templates USING btree (prompt_type, name);


--
-- Name: idx_remark_comments_author_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_remark_comments_author_id ON public.remark_comments USING btree (author_id);


--
-- Name: idx_remark_comments_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_remark_comments_created_at ON public.remark_comments USING btree (created_at);


--
-- Name: idx_remark_comments_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_remark_comments_parent_id ON public.remark_comments USING btree (parent_comment_id);


--
-- Name: idx_remark_comments_remark_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_remark_comments_remark_id ON public.remark_comments USING btree (remark_id);


--
-- Name: idx_review_checklists_deliverable_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_checklists_deliverable_type ON public.review_checklists USING btree (deliverable_type);


--
-- Name: idx_review_checklists_discipline; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_checklists_discipline ON public.review_checklists USING btree (discipline);


--
-- Name: idx_review_checklists_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_checklists_is_active ON public.review_checklists USING btree (is_active);


--
-- Name: idx_review_remarks_review_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_remarks_review_id ON public.review_remarks USING btree (review_id);


--
-- Name: idx_review_remarks_severity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_remarks_severity ON public.review_remarks USING btree (severity);


--
-- Name: idx_review_remarks_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_review_remarks_status ON public.review_remarks USING btree (status);


--
-- Name: idx_tasks_assigned_to_participant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_assigned_to_participant ON public.tasks USING btree (assigned_to_participant_id);


--
-- Name: idx_tasks_is_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_is_read ON public.tasks USING btree (is_read) WHERE (is_read = false);


--
-- Name: idx_workflow_config_deliverable_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_workflow_config_deliverable_type ON public.review_workflow_configs USING btree (deliverable_type);


--
-- Name: idx_workflow_config_discipline; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_workflow_config_discipline ON public.review_workflow_configs USING btree (discipline);


--
-- Name: idx_workflow_config_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_workflow_config_lookup ON public.review_workflow_configs USING btree (project_id, discipline, deliverable_type);


--
-- Name: idx_workflow_config_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_workflow_config_project ON public.review_workflow_configs USING btree (project_id);


--
-- Name: ix_departments_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_departments_code ON public.departments USING btree (code);


--
-- Name: ix_departments_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_departments_name ON public.departments USING btree (name);


--
-- Name: ix_designations_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_designations_code ON public.designations USING btree (code);


--
-- Name: ix_designations_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_designations_title ON public.designations USING btree (title);


--
-- Name: ix_execution_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_action ON public.execution_logs USING btree (action);


--
-- Name: ix_execution_logs_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_category ON public.execution_logs USING btree (category);


--
-- Name: ix_execution_logs_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_execution_id ON public.execution_logs USING btree (execution_id);


--
-- Name: ix_execution_logs_parent_log_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_parent_log_id ON public.execution_logs USING btree (parent_log_id);


--
-- Name: ix_execution_logs_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_project_id ON public.execution_logs USING btree (project_id);


--
-- Name: ix_execution_logs_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_execution_logs_timestamp ON public.execution_logs USING btree ("timestamp");


--
-- Name: ix_group_tool; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_group_tool ON public.tool_group_memberships USING btree (group_id, tool_id);


--
-- Name: ix_meeting_documents_document_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_document_type ON public.meeting_documents USING btree (document_type);


--
-- Name: ix_meeting_documents_meeting; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_meeting ON public.meeting_documents USING btree (meeting_id);


--
-- Name: ix_meeting_documents_meeting_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_meeting_id ON public.meeting_documents USING btree (meeting_id);


--
-- Name: ix_meeting_documents_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_project ON public.meeting_documents USING btree (project_id);


--
-- Name: ix_meeting_documents_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_project_id ON public.meeting_documents USING btree (project_id);


--
-- Name: ix_meeting_documents_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_meeting_documents_type ON public.meeting_documents USING btree (document_type);


--
-- Name: ix_participant_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_project ON public.participant_project_assignments USING btree (participant_id, project_id);


--
-- Name: ix_participant_project_assignments_participant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_project_assignments_participant_id ON public.participant_project_assignments USING btree (participant_id);


--
-- Name: ix_participant_project_assignments_project_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_project_assignments_project_id ON public.participant_project_assignments USING btree (project_id);


--
-- Name: ix_participant_tool_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_tool_active ON public.participant_tool_assignments USING btree (participant_id, is_active);


--
-- Name: ix_participant_tool_assignments_participant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_tool_assignments_participant_id ON public.participant_tool_assignments USING btree (participant_id);


--
-- Name: ix_participant_tool_assignments_source_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_tool_assignments_source_group_id ON public.participant_tool_assignments USING btree (source_group_id);


--
-- Name: ix_participant_tool_assignments_tool_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participant_tool_assignments_tool_id ON public.participant_tool_assignments USING btree (tool_id);


--
-- Name: ix_participants_department_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participants_department_id ON public.participants USING btree (department_id);


--
-- Name: ix_participants_designation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participants_designation_id ON public.participants USING btree (designation_id);


--
-- Name: ix_participants_discipline; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participants_discipline ON public.participants USING btree (discipline);


--
-- Name: ix_participants_is_hod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participants_is_hod ON public.participants USING btree (is_hod);


--
-- Name: ix_participants_participant_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_participants_participant_key ON public.participants USING btree (participant_key);


--
-- Name: ix_review_checklists_deliverable_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_checklists_deliverable_type ON public.review_checklists USING btree (deliverable_type);


--
-- Name: ix_review_checklists_discipline; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_checklists_discipline ON public.review_checklists USING btree (discipline);


--
-- Name: ix_review_checklists_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_checklists_is_active ON public.review_checklists USING btree (is_active);


--
-- Name: ix_tasks_depends_on; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tasks_depends_on ON public.tasks USING btree (depends_on_task_id);


--
-- Name: ix_tasks_requires_approval; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tasks_requires_approval ON public.tasks USING btree (requires_approval);


--
-- Name: ix_tool_group_memberships_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tool_group_memberships_group_id ON public.tool_group_memberships USING btree (group_id);


--
-- Name: ix_tool_group_memberships_tool_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tool_group_memberships_tool_id ON public.tool_group_memberships USING btree (tool_id);


--
-- Name: ix_tools_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tools_category ON public.tools USING btree (category);


--
-- Name: ix_tools_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tools_is_active ON public.tools USING btree (is_active);


--
-- Name: ix_tools_is_base_tool; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tools_is_base_tool ON public.tools USING btree (is_base_tool);


--
-- Name: ix_tools_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_tools_name ON public.tools USING btree (name);


--
-- Name: ix_tools_tool_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tools_tool_group_id ON public.tools USING btree (tool_group_id);


--
-- Name: prompt_templates trigger_prompt_templates_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER trigger_prompt_templates_updated_at BEFORE UPDATE ON public.prompt_templates FOR EACH ROW EXECUTE FUNCTION public.update_prompt_templates_updated_at();


--
-- Name: deliverables update_deliverables_updated_at; Type: TRIGGER; Schema: public; Owner: supabase_admin
--

CREATE TRIGGER update_deliverables_updated_at BEFORE UPDATE ON public.deliverables FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: review_checklists update_review_checklists_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_review_checklists_updated_at BEFORE UPDATE ON public.review_checklists FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: agenda_items agenda_items_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agenda_items
    ADD CONSTRAINT agenda_items_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(meeting_id);


--
-- Name: approval_requests approval_requests_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: approval_requests approval_requests_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE SET NULL;


--
-- Name: approval_requests approval_requests_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id) ON DELETE SET NULL;


--
-- Name: approval_requests approval_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: approval_requests approval_requests_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.deliverable_reviews(review_id) ON DELETE SET NULL;


--
-- Name: approval_requests approval_requests_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_requests
    ADD CONSTRAINT approval_requests_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE SET NULL;


--
-- Name: approvals approvals_approval_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approvals
    ADD CONSTRAINT approvals_approval_id_fkey FOREIGN KEY (approval_id) REFERENCES public.approval_requests(approval_id) ON DELETE CASCADE;


--
-- Name: approvals approvals_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approvals
    ADD CONSTRAINT approvals_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverable_documents deliverable_documents_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_documents
    ADD CONSTRAINT deliverable_documents_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE CASCADE;


--
-- Name: deliverable_documents deliverable_documents_linked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_documents
    ADD CONSTRAINT deliverable_documents_linked_by_fkey FOREIGN KEY (linked_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverable_reviews deliverable_reviews_checklist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_reviews
    ADD CONSTRAINT deliverable_reviews_checklist_id_fkey FOREIGN KEY (checklist_id) REFERENCES public.review_checklists(checklist_id) ON DELETE SET NULL;


--
-- Name: deliverable_reviews deliverable_reviews_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_reviews
    ADD CONSTRAINT deliverable_reviews_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE CASCADE;


--
-- Name: deliverable_reviews deliverable_reviews_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_reviews
    ADD CONSTRAINT deliverable_reviews_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverable_reviews deliverable_reviews_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_reviews
    ADD CONSTRAINT deliverable_reviews_version_id_fkey FOREIGN KEY (version_id) REFERENCES public.deliverable_versions(version_id) ON DELETE SET NULL;


--
-- Name: deliverable_tasks deliverable_tasks_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_tasks
    ADD CONSTRAINT deliverable_tasks_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE CASCADE;


--
-- Name: deliverable_tasks deliverable_tasks_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_tasks
    ADD CONSTRAINT deliverable_tasks_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- Name: deliverable_versions deliverable_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_versions
    ADD CONSTRAINT deliverable_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverable_versions deliverable_versions_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliverable_versions
    ADD CONSTRAINT deliverable_versions_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE CASCADE;


--
-- Name: deliverables deliverables_assigned_to_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_assigned_to_participant_id_fkey FOREIGN KEY (assigned_to_participant_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverables deliverables_created_by_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_created_by_participant_id_fkey FOREIGN KEY (created_by_participant_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: deliverables deliverables_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id) ON DELETE SET NULL;


--
-- Name: deliverables deliverables_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- Name: deliverables deliverables_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE SET NULL;


--
-- Name: deliverables deliverables_workflow_config_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_workflow_config_id_fkey FOREIGN KEY (workflow_config_id) REFERENCES public.review_workflow_configs(config_id) ON DELETE SET NULL;


--
-- Name: escalation_events escalation_events_deliverable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalation_events
    ADD CONSTRAINT escalation_events_deliverable_id_fkey FOREIGN KEY (deliverable_id) REFERENCES public.deliverables(deliverable_id) ON DELETE CASCADE;


--
-- Name: escalation_events escalation_events_escalated_to_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalation_events
    ADD CONSTRAINT escalation_events_escalated_to_participant_id_fkey FOREIGN KEY (escalated_to_participant_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: escalation_events escalation_events_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalation_events
    ADD CONSTRAINT escalation_events_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.deliverable_reviews(review_id) ON DELETE SET NULL;


--
-- Name: execution_logs execution_logs_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: execution_logs execution_logs_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(meeting_id);


--
-- Name: execution_logs execution_logs_parent_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_parent_log_id_fkey FOREIGN KEY (parent_log_id) REFERENCES public.execution_logs(log_id);


--
-- Name: execution_logs execution_logs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: execution_logs execution_logs_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id);


--
-- Name: execution_logs execution_logs_tool_call_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_logs
    ADD CONSTRAINT execution_logs_tool_call_id_fkey FOREIGN KEY (tool_call_id) REFERENCES public.tool_calls(tool_call_id);


--
-- Name: execution_sessions execution_sessions_hod_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_sessions
    ADD CONSTRAINT execution_sessions_hod_participant_id_fkey FOREIGN KEY (hod_participant_id) REFERENCES public.participants(participant_id);


--
-- Name: execution_sessions execution_sessions_parent_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_sessions
    ADD CONSTRAINT execution_sessions_parent_execution_id_fkey FOREIGN KEY (parent_execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: execution_sessions execution_sessions_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_sessions
    ADD CONSTRAINT execution_sessions_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: notifications fk_notifications_participant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_participant FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id) ON DELETE CASCADE;


--
-- Name: notifications fk_notifications_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_project FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- Name: global_chat_messages global_chat_messages_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.global_chat_messages
    ADD CONSTRAINT global_chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.global_chat_sessions(id) ON DELETE CASCADE;


--
-- Name: global_chat_sessions global_chat_sessions_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.global_chat_sessions
    ADD CONSTRAINT global_chat_sessions_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: global_chat_sessions global_chat_sessions_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.global_chat_sessions
    ADD CONSTRAINT global_chat_sessions_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: meeting_documents meeting_documents_agenda_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_documents
    ADD CONSTRAINT meeting_documents_agenda_item_id_fkey FOREIGN KEY (agenda_item_id) REFERENCES public.agenda_items(agenda_item_id);


--
-- Name: meeting_documents meeting_documents_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_documents
    ADD CONSTRAINT meeting_documents_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: meeting_documents meeting_documents_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_documents
    ADD CONSTRAINT meeting_documents_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(meeting_id);


--
-- Name: meeting_documents meeting_documents_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_documents
    ADD CONSTRAINT meeting_documents_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: meetings meetings_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: meetings meetings_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: participant_project_assignments participant_project_assignments_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_project_assignments
    ADD CONSTRAINT participant_project_assignments_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: participant_project_assignments participant_project_assignments_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_project_assignments
    ADD CONSTRAINT participant_project_assignments_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: participant_tool_assignments participant_tool_assignments_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_tool_assignments
    ADD CONSTRAINT participant_tool_assignments_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id) ON DELETE CASCADE;


--
-- Name: participant_tool_assignments participant_tool_assignments_source_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_tool_assignments
    ADD CONSTRAINT participant_tool_assignments_source_group_id_fkey FOREIGN KEY (source_group_id) REFERENCES public.tool_groups(group_id);


--
-- Name: participant_tool_assignments participant_tool_assignments_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participant_tool_assignments
    ADD CONSTRAINT participant_tool_assignments_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(tool_id) ON DELETE CASCADE;


--
-- Name: participants participants_default_tool_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_default_tool_group_id_fkey FOREIGN KEY (default_tool_group_id) REFERENCES public.tool_groups(group_id);


--
-- Name: participants participants_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: participants participants_designation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES public.designations(designation_id);


--
-- Name: participants participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: project_chat_messages project_chat_messages_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_chat_messages
    ADD CONSTRAINT project_chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.project_chat_sessions(id) ON DELETE CASCADE;


--
-- Name: project_chat_sessions project_chat_sessions_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_chat_sessions
    ADD CONSTRAINT project_chat_sessions_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: project_chat_sessions project_chat_sessions_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_chat_sessions
    ADD CONSTRAINT project_chat_sessions_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: projects projects_kickoff_prep_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_kickoff_prep_meeting_id_fkey FOREIGN KEY (kickoff_prep_meeting_id) REFERENCES public.meetings(meeting_id);


--
-- Name: prompt_feedback prompt_feedback_feedback_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_feedback
    ADD CONSTRAINT prompt_feedback_feedback_by_fkey FOREIGN KEY (feedback_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: prompt_feedback prompt_feedback_invocation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_feedback
    ADD CONSTRAINT prompt_feedback_invocation_id_fkey FOREIGN KEY (invocation_id) REFERENCES public.prompt_invocations(invocation_id) ON DELETE CASCADE;


--
-- Name: prompt_invocations prompt_invocations_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id) ON DELETE SET NULL;


--
-- Name: prompt_invocations prompt_invocations_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(meeting_id) ON DELETE SET NULL;


--
-- Name: prompt_invocations prompt_invocations_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: prompt_invocations prompt_invocations_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE SET NULL;


--
-- Name: prompt_invocations prompt_invocations_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE SET NULL;


--
-- Name: prompt_invocations prompt_invocations_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_invocations
    ADD CONSTRAINT prompt_invocations_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.prompt_templates(template_id) ON DELETE SET NULL;


--
-- Name: prompt_templates prompt_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: prompt_templates prompt_templates_previous_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_previous_version_id_fkey FOREIGN KEY (previous_version_id) REFERENCES public.prompt_templates(template_id) ON DELETE SET NULL;


--
-- Name: remark_comments remark_comments_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remark_comments
    ADD CONSTRAINT remark_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: remark_comments remark_comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remark_comments
    ADD CONSTRAINT remark_comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.remark_comments(comment_id) ON DELETE CASCADE;


--
-- Name: remark_comments remark_comments_remark_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.remark_comments
    ADD CONSTRAINT remark_comments_remark_id_fkey FOREIGN KEY (remark_id) REFERENCES public.review_remarks(remark_id) ON DELETE CASCADE;


--
-- Name: review_checklists review_checklists_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_checklists
    ADD CONSTRAINT review_checklists_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: review_remarks review_remarks_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_remarks
    ADD CONSTRAINT review_remarks_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: review_remarks review_remarks_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_remarks
    ADD CONSTRAINT review_remarks_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.deliverable_reviews(review_id) ON DELETE CASCADE;


--
-- Name: review_workflow_configs review_workflow_configs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_workflow_configs
    ADD CONSTRAINT review_workflow_configs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.participants(participant_id) ON DELETE SET NULL;


--
-- Name: review_workflow_configs review_workflow_configs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_workflow_configs
    ADD CONSTRAINT review_workflow_configs_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- Name: tasks tasks_assigned_by_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_by_participant_id_fkey FOREIGN KEY (assigned_by_participant_id) REFERENCES public.participants(participant_id);


--
-- Name: tasks tasks_assigned_to_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assigned_to_participant_id_fkey FOREIGN KEY (assigned_to_participant_id) REFERENCES public.participants(participant_id);


--
-- Name: tasks tasks_depends_on_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_depends_on_task_id_fkey FOREIGN KEY (depends_on_task_id) REFERENCES public.tasks(task_id);


--
-- Name: tasks tasks_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: tasks tasks_parent_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_parent_task_id_fkey FOREIGN KEY (parent_task_id) REFERENCES public.tasks(task_id);


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id);


--
-- Name: tool_assignment_audit tool_assignment_audit_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_assignment_audit
    ADD CONSTRAINT tool_assignment_audit_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.tool_groups(group_id);


--
-- Name: tool_assignment_audit tool_assignment_audit_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_assignment_audit
    ADD CONSTRAINT tool_assignment_audit_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: tool_assignment_audit tool_assignment_audit_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_assignment_audit
    ADD CONSTRAINT tool_assignment_audit_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(tool_id);


--
-- Name: tool_calls tool_calls_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_calls
    ADD CONSTRAINT tool_calls_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: tool_calls tool_calls_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_calls
    ADD CONSTRAINT tool_calls_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id);


--
-- Name: tool_group_memberships tool_group_memberships_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_group_memberships
    ADD CONSTRAINT tool_group_memberships_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.tool_groups(group_id) ON DELETE CASCADE;


--
-- Name: tool_group_memberships tool_group_memberships_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_group_memberships
    ADD CONSTRAINT tool_group_memberships_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(tool_id) ON DELETE CASCADE;


--
-- Name: tool_results tool_results_tool_call_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_results
    ADD CONSTRAINT tool_results_tool_call_id_fkey FOREIGN KEY (tool_call_id) REFERENCES public.tool_calls(tool_call_id);


--
-- Name: tools tools_tool_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tool_group_id_fkey FOREIGN KEY (tool_group_id) REFERENCES public.tool_groups(group_id) ON DELETE SET NULL;


--
-- Name: transcript_entries transcript_entries_execution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_entries
    ADD CONSTRAINT transcript_entries_execution_id_fkey FOREIGN KEY (execution_id) REFERENCES public.execution_sessions(execution_id);


--
-- Name: transcript_entries transcript_entries_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_entries
    ADD CONSTRAINT transcript_entries_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(meeting_id);


--
-- Name: transcript_entries transcript_entries_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_entries
    ADD CONSTRAINT transcript_entries_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id);


--
-- Name: documents Allow all document operations; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Allow all document operations" ON public.documents USING (true) WITH CHECK (true);


--
-- Name: participant_project_assignments Allow anon DELETE; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow anon DELETE" ON public.participant_project_assignments FOR DELETE USING (true);


--
-- Name: participant_project_assignments Allow anon INSERT; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow anon INSERT" ON public.participant_project_assignments FOR INSERT WITH CHECK (true);


--
-- Name: participant_project_assignments Allow anon SELECT; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow anon SELECT" ON public.participant_project_assignments FOR SELECT USING (true);


--
-- Name: participant_project_assignments Allow anon UPDATE; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow anon UPDATE" ON public.participant_project_assignments FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: documents Allow insert for all; Type: POLICY; Schema: public; Owner: supabase_admin
--

CREATE POLICY "Allow insert for all" ON public.documents FOR INSERT WITH CHECK (true);


--
-- Name: participant_project_assignments Allow insert participant_project_assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow insert participant_project_assignments" ON public.participant_project_assignments FOR INSERT TO authenticated, anon WITH CHECK (true);


--
-- Name: notifications Allow read notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read notifications" ON public.notifications FOR SELECT USING (true);


--
-- Name: participant_project_assignments Allow read participant_project_assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow read participant_project_assignments" ON public.participant_project_assignments FOR SELECT TO authenticated, anon USING (true);


--
-- Name: notifications Allow update notifications; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow update notifications" ON public.notifications FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: participant_project_assignments Allow update participant_project_assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow update participant_project_assignments" ON public.participant_project_assignments FOR UPDATE TO authenticated, anon USING (true) WITH CHECK (true);


--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: participant_project_assignments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.participant_project_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION get_user_notifications(p_participant_id text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_user_notifications(p_participant_id text) TO anon;
GRANT ALL ON FUNCTION public.get_user_notifications(p_participant_id text) TO authenticated;


--
-- Name: TABLE agenda_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.agenda_items TO anon;
GRANT ALL ON TABLE public.agenda_items TO authenticated;
GRANT ALL ON TABLE public.agenda_items TO service_role;


--
-- Name: TABLE boq_weights; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.boq_weights TO anon;
GRANT SELECT ON TABLE public.boq_weights TO authenticated;
GRANT ALL ON TABLE public.boq_weights TO service_role;


--
-- Name: SEQUENCE boq_weights_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.boq_weights_id_seq TO service_role;


--
-- Name: TABLE deliverable_documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.deliverable_documents TO anon;
GRANT SELECT ON TABLE public.deliverable_documents TO authenticated;


--
-- Name: TABLE deliverables; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.deliverables TO service_role;
GRANT SELECT ON TABLE public.deliverables TO anon;
GRANT SELECT ON TABLE public.deliverables TO authenticated;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.projects TO anon;
GRANT ALL ON TABLE public.projects TO authenticated;
GRANT ALL ON TABLE public.projects TO service_role;


--
-- Name: TABLE deliverable_tasks; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.deliverable_tasks TO anon;
GRANT SELECT ON TABLE public.deliverable_tasks TO authenticated;


--
-- Name: TABLE departments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.departments TO anon;
GRANT ALL ON TABLE public.departments TO authenticated;
GRANT ALL ON TABLE public.departments TO service_role;


--
-- Name: TABLE designations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.designations TO anon;
GRANT ALL ON TABLE public.designations TO authenticated;
GRANT ALL ON TABLE public.designations TO service_role;


--
-- Name: TABLE document_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.document_types TO anon;
GRANT SELECT ON TABLE public.document_types TO authenticated;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.documents TO anon;
GRANT ALL ON TABLE public.documents TO authenticated;
GRANT ALL ON TABLE public.documents TO service_role;


--
-- Name: TABLE escalation_events; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.escalation_events TO anon;
GRANT SELECT ON TABLE public.escalation_events TO authenticated;


--
-- Name: TABLE execution_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.execution_logs TO anon;
GRANT ALL ON TABLE public.execution_logs TO authenticated;
GRANT ALL ON TABLE public.execution_logs TO service_role;


--
-- Name: TABLE execution_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.execution_sessions TO anon;
GRANT ALL ON TABLE public.execution_sessions TO authenticated;
GRANT ALL ON TABLE public.execution_sessions TO service_role;


--
-- Name: TABLE global_chat_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.global_chat_messages TO anon;
GRANT ALL ON TABLE public.global_chat_messages TO authenticated;


--
-- Name: TABLE global_chat_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.global_chat_sessions TO anon;
GRANT ALL ON TABLE public.global_chat_sessions TO authenticated;


--
-- Name: TABLE meeting_documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.meeting_documents TO anon;
GRANT ALL ON TABLE public.meeting_documents TO authenticated;
GRANT ALL ON TABLE public.meeting_documents TO service_role;


--
-- Name: TABLE meetings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.meetings TO anon;
GRANT ALL ON TABLE public.meetings TO authenticated;
GRANT ALL ON TABLE public.meetings TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE public.notifications TO anon;
GRANT SELECT,UPDATE ON TABLE public.notifications TO authenticated;


--
-- Name: TABLE participant_project_assignments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.participant_project_assignments TO anon;
GRANT ALL ON TABLE public.participant_project_assignments TO authenticated;
GRANT ALL ON TABLE public.participant_project_assignments TO service_role;


--
-- Name: TABLE participant_tool_assignments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.participant_tool_assignments TO anon;
GRANT ALL ON TABLE public.participant_tool_assignments TO authenticated;
GRANT ALL ON TABLE public.participant_tool_assignments TO service_role;


--
-- Name: TABLE participants; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.participants TO anon;
GRANT ALL ON TABLE public.participants TO authenticated;
GRANT ALL ON TABLE public.participants TO service_role;


--
-- Name: TABLE project_chat_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_chat_messages TO anon;
GRANT ALL ON TABLE public.project_chat_messages TO authenticated;


--
-- Name: TABLE project_chat_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.project_chat_sessions TO anon;
GRANT ALL ON TABLE public.project_chat_sessions TO authenticated;


--
-- Name: TABLE prompt_feedback; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.prompt_feedback TO postgres;


--
-- Name: TABLE prompt_invocations; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.prompt_invocations TO postgres;


--
-- Name: TABLE prompt_templates; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.prompt_templates TO postgres;


--
-- Name: TABLE remark_comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.remark_comments TO anon;
GRANT SELECT ON TABLE public.remark_comments TO authenticated;


--
-- Name: TABLE review_workflow_configs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.review_workflow_configs TO anon;
GRANT SELECT ON TABLE public.review_workflow_configs TO authenticated;


--
-- Name: TABLE tasks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tasks TO anon;
GRANT ALL ON TABLE public.tasks TO authenticated;
GRANT ALL ON TABLE public.tasks TO service_role;


--
-- Name: TABLE tool_assignment_audit; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tool_assignment_audit TO anon;
GRANT ALL ON TABLE public.tool_assignment_audit TO authenticated;
GRANT ALL ON TABLE public.tool_assignment_audit TO service_role;


--
-- Name: TABLE tool_calls; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tool_calls TO anon;
GRANT ALL ON TABLE public.tool_calls TO authenticated;
GRANT ALL ON TABLE public.tool_calls TO service_role;


--
-- Name: TABLE tool_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tool_groups TO anon;
GRANT ALL ON TABLE public.tool_groups TO authenticated;
GRANT ALL ON TABLE public.tool_groups TO service_role;


--
-- Name: TABLE tool_results; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tool_results TO anon;
GRANT ALL ON TABLE public.tool_results TO authenticated;
GRANT ALL ON TABLE public.tool_results TO service_role;


--
-- Name: TABLE tools; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tools TO anon;
GRANT ALL ON TABLE public.tools TO authenticated;
GRANT ALL ON TABLE public.tools TO service_role;


--
-- Name: TABLE transcript_entries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.transcript_entries TO anon;
GRANT ALL ON TABLE public.transcript_entries TO authenticated;
GRANT ALL ON TABLE public.transcript_entries TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO authenticated;


--
-- PostgreSQL database dump complete
--

