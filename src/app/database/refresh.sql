--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: dm_user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE dm_user_role AS ENUM (
    'dm_admin',
    'dm_captain',
    'dm_user',
    'dm_super_admin'
);


ALTER TYPE public.dm_user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: dm_game_properties; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_game_properties (
    game_id uuid,
    key character varying(100),
    value bytea,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_game_properties OWNER TO postgres;

--
-- Name: dm_games; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_games (
    game_id uuid NOT NULL,
    game_name character varying(100) NOT NULL,
    game_started boolean DEFAULT false,
    game_password character varying(100) DEFAULT NULL::character varying,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_games OWNER TO postgres;

--
-- Name: dm_kill_timers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_kill_timers (
    game_id uuid,
    create_ts timestamp without time zone DEFAULT now(),
    execute_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_kill_timers OWNER TO postgres;

--
-- Name: dm_teams; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_teams (
    team_id uuid NOT NULL,
    game_id uuid NOT NULL,
    team_name character varying(100),
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_teams OWNER TO postgres;

--
-- Name: dm_user_game_mapping; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_user_game_mapping (
    user_id uuid NOT NULL,
    game_id uuid NOT NULL,
    alive boolean DEFAULT true,
    kills integer DEFAULT 0,
    user_role dm_user_role DEFAULT 'dm_user'::dm_user_role NOT NULL,
    team_id uuid,
    secret character varying(100) DEFAULT ''::character varying NOT NULL,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_user_game_mapping OWNER TO postgres;

--
-- Name: dm_user_properties; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_user_properties (
    user_id uuid NOT NULL,
    key character varying(100) NOT NULL,
    value bytea,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_user_properties OWNER TO postgres;

--
-- Name: dm_user_targets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_user_targets (
    user_id uuid NOT NULL,
    target_id uuid NOT NULL,
    game_id uuid NOT NULL,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_user_targets OWNER TO postgres;

--
-- Name: dm_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dm_users (
    user_id uuid NOT NULL,
    username character varying(256) NOT NULL,
    email character varying(256) DEFAULT ''::character varying NOT NULL,
    facebook_id bigint NOT NULL,
    facebook_token character varying,
    create_ts timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dm_users OWNER TO postgres;


--
-- Name: dm_games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dm_games
    ADD CONSTRAINT dm_games_pkey PRIMARY KEY (game_id);


--
-- Name: dm_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dm_teams
    ADD CONSTRAINT dm_teams_pkey PRIMARY KEY (team_id);


--
-- Name: dm_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dm_users
    ADD CONSTRAINT dm_users_pkey PRIMARY KEY (user_id);


--
-- Name: dm_teams_game_id_team_name_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_teams_game_id_team_name_idx ON dm_teams USING btree (game_id, team_name);


--
-- Name: dm_user_game_mapping_game_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dm_user_game_mapping_game_id_idx ON dm_user_game_mapping USING btree (game_id);


--
-- Name: dm_user_game_mapping_user_id_game_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_user_game_mapping_user_id_game_id_idx ON dm_user_game_mapping USING btree (user_id, game_id);


--
-- Name: dm_user_properties_user_id_key_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_user_properties_user_id_key_idx ON dm_user_properties USING btree (user_id, key);


--
-- Name: dm_user_targets_game_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX dm_user_targets_game_id_idx ON dm_user_targets USING btree (game_id);


--
-- Name: dm_user_targets_target_id_game_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_user_targets_target_id_game_id_idx ON dm_user_targets USING btree (target_id, game_id);


--
-- Name: dm_user_targets_user_id_game_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_user_targets_user_id_game_id_idx ON dm_user_targets USING btree (user_id, game_id);


--
-- Name: dm_users_email_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_users_email_idx ON dm_users USING btree (username);


--
-- Name: dm_users_facebook_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX dm_users_facebook_id_idx ON dm_users USING btree (facebook_id);


--
-- Name: single_kill_timer; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX single_kill_timer ON dm_kill_timers USING btree (game_id);


--
-- Name: unique_game_name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_game_name ON dm_games USING btree (lower((game_name)::text));


--
-- Name: dm_game_properties_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_game_properties
    ADD CONSTRAINT dm_game_properties_game_id_fkey FOREIGN KEY (game_id) REFERENCES dm_games(game_id) ON DELETE CASCADE;


--
-- Name: dm_kill_timers_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_kill_timers
    ADD CONSTRAINT dm_kill_timers_game_id_fkey FOREIGN KEY (game_id) REFERENCES dm_games(game_id) ON DELETE CASCADE;


--
-- Name: dm_teams_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_teams
    ADD CONSTRAINT dm_teams_game_id_fkey FOREIGN KEY (game_id) REFERENCES dm_games(game_id) ON DELETE CASCADE;


--
-- Name: dm_user_game_mapping_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_game_mapping
    ADD CONSTRAINT dm_user_game_mapping_game_id_fkey FOREIGN KEY (game_id) REFERENCES dm_games(game_id) ON DELETE CASCADE;


--
-- Name: dm_user_game_mapping_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_game_mapping
    ADD CONSTRAINT dm_user_game_mapping_team_fkey FOREIGN KEY (team_id) REFERENCES dm_teams(team_id);


--
-- Name: dm_user_game_mapping_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_game_mapping
    ADD CONSTRAINT dm_user_game_mapping_user_id_fkey FOREIGN KEY (user_id) REFERENCES dm_users(user_id) ON DELETE CASCADE;


--
-- Name: dm_user_properties_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_properties
    ADD CONSTRAINT dm_user_properties_user_id_fkey FOREIGN KEY (user_id) REFERENCES dm_users(user_id) ON DELETE CASCADE;


--
-- Name: dm_user_targets_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_targets
    ADD CONSTRAINT dm_user_targets_game_id_fkey FOREIGN KEY (game_id) REFERENCES dm_games(game_id) ON DELETE CASCADE;


--
-- Name: dm_user_targets_target_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_targets
    ADD CONSTRAINT dm_user_targets_target_id_fkey FOREIGN KEY (target_id) REFERENCES dm_users(user_id) ON DELETE CASCADE;


--
-- Name: dm_user_targets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dm_user_targets
    ADD CONSTRAINT dm_user_targets_user_id_fkey FOREIGN KEY (user_id) REFERENCES dm_users(user_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM "postgres";
GRANT ALL ON SCHEMA public TO "postgres";
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

