--
-- PostgreSQL database dump
--

-- Dumped from database version 12.20 (Ubuntu 12.20-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.20 (Ubuntu 12.20-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tbl_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_address (
    id integer NOT NULL,
    customer_id integer,
    latlng point,
    receiver_name character varying(100),
    phone_number character varying(15),
    province character varying(50),
    district character varying(50),
    commune character varying(50),
    house character varying(100)
);


ALTER TABLE public.tbl_address OWNER TO postgres;

--
-- Name: tbl_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_address_id_seq OWNER TO postgres;

--
-- Name: tbl_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_address_id_seq OWNED BY public.tbl_address.id;


--
-- Name: tbl_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_category (
    id integer NOT NULL,
    category_name character varying(255),
    image text
);


ALTER TABLE public.tbl_category OWNER TO postgres;

--
-- Name: tbl_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_category_id_seq OWNER TO postgres;

--
-- Name: tbl_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_category_id_seq OWNED BY public.tbl_category.id;


--
-- Name: tbl_favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_favorites (
    id integer NOT NULL,
    customer_id integer,
    product_id integer,
    favorite boolean
);


ALTER TABLE public.tbl_favorites OWNER TO postgres;

--
-- Name: tbl_favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_favorites_id_seq OWNER TO postgres;

--
-- Name: tbl_favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_favorites_id_seq OWNED BY public.tbl_favorites.id;


--
-- Name: tbl_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_order (
    ord_id integer NOT NULL,
    customer_id integer,
    customer_name character varying(255),
    device_id text,
    payment_type character varying(255),
    status_id integer,
    seller character varying(255),
    discount integer,
    total_amount double precision,
    address_id integer
);


ALTER TABLE public.tbl_order OWNER TO postgres;

--
-- Name: tbl_order_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_order_detail (
    ord_id integer NOT NULL,
    product_id integer NOT NULL,
    qty integer,
    amount double precision,
    order_date text
);


ALTER TABLE public.tbl_order_detail OWNER TO postgres;

--
-- Name: tbl_order_ord_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_order_ord_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_order_ord_id_seq OWNER TO postgres;

--
-- Name: tbl_order_ord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_order_ord_id_seq OWNED BY public.tbl_order.ord_id;


--
-- Name: tbl_order_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_order_status (
    id integer NOT NULL,
    status character varying(255)
);


ALTER TABLE public.tbl_order_status OWNER TO postgres;

--
-- Name: tbl_order_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_order_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_order_status_id_seq OWNER TO postgres;

--
-- Name: tbl_order_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_order_status_id_seq OWNED BY public.tbl_order_status.id;


--
-- Name: tbl_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_product (
    product_id integer NOT NULL,
    product_name character varying(255),
    qty integer,
    "desc" character varying(255),
    image text,
    sold integer,
    price_in double precision,
    price_out double precision,
    favid integer,
    category_id integer
);


ALTER TABLE public.tbl_product OWNER TO postgres;

--
-- Name: tbl_product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_product_product_id_seq OWNER TO postgres;

--
-- Name: tbl_product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_product_product_id_seq OWNED BY public.tbl_product.product_id;


--
-- Name: tbl_sale_report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_sale_report (
    id integer NOT NULL,
    customer_name character varying(255) NOT NULL,
    units integer NOT NULL,
    payment_type character varying(50) NOT NULL,
    amount_sale numeric(10,2) NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tbl_sale_report OWNER TO postgres;

--
-- Name: tbl_sale_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_sale_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_sale_report_id_seq OWNER TO postgres;

--
-- Name: tbl_sale_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_sale_report_id_seq OWNED BY public.tbl_sale_report.id;


--
-- Name: tbl_slides; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_slides (
    id integer NOT NULL,
    title character varying,
    image character varying
);


ALTER TABLE public.tbl_slides OWNER TO postgres;

--
-- Name: tbl_slides_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_slides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_slides_id_seq OWNER TO postgres;

--
-- Name: tbl_slides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_slides_id_seq OWNED BY public.tbl_slides.id;


--
-- Name: tbl_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tbl_user (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(15) NOT NULL,
    is_admin boolean DEFAULT false,
    active boolean DEFAULT true,
    password character varying(255) NOT NULL,
    photo character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    token character varying(255)
);


ALTER TABLE public.tbl_user OWNER TO postgres;

--
-- Name: tbl_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tbl_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbl_user_id_seq OWNER TO postgres;

--
-- Name: tbl_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tbl_user_id_seq OWNED BY public.tbl_user.id;


--
-- Name: tbl_address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_address ALTER COLUMN id SET DEFAULT nextval('public.tbl_address_id_seq'::regclass);


--
-- Name: tbl_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_category ALTER COLUMN id SET DEFAULT nextval('public.tbl_category_id_seq'::regclass);


--
-- Name: tbl_favorites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_favorites ALTER COLUMN id SET DEFAULT nextval('public.tbl_favorites_id_seq'::regclass);


--
-- Name: tbl_order ord_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order ALTER COLUMN ord_id SET DEFAULT nextval('public.tbl_order_ord_id_seq'::regclass);


--
-- Name: tbl_order_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order_status ALTER COLUMN id SET DEFAULT nextval('public.tbl_order_status_id_seq'::regclass);


--
-- Name: tbl_product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_product ALTER COLUMN product_id SET DEFAULT nextval('public.tbl_product_product_id_seq'::regclass);


--
-- Name: tbl_sale_report id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sale_report ALTER COLUMN id SET DEFAULT nextval('public.tbl_sale_report_id_seq'::regclass);


--
-- Name: tbl_slides id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_slides ALTER COLUMN id SET DEFAULT nextval('public.tbl_slides_id_seq'::regclass);


--
-- Name: tbl_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_user ALTER COLUMN id SET DEFAULT nextval('public.tbl_user_id_seq'::regclass);


--
-- Data for Name: tbl_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_address (id, customer_id, latlng, receiver_name, phone_number, province, district, commune, house) FROM stdin;
2	1	(37.4219983,-122.084)	nea	0974278786	ratanakiri	banlung	banlung	store
6	1	(37.4219983,-122.084)	aba	123	123	123		
7	18	(37.4219983,-122.084)	nes	123123	rtk	banlung		
12	17	(37.411823851918896,-122.07803159952165)	nea	0974278786	California	Santa Clara County	Shoreline Overpass	
13	19	(11.569563004287103,104.90264560955421)	sokon	0968006877	Phnom penh	veal sbov	kdey takoy	1
14	17	(11.5679879,104.8946664)	panha rith	0973813584	pp	tk		
15	20	(11.567986,104.8946644)	Sovan Rum	+85510630676	Phnom Penh	Khan Tuol Kork	No. 86A	
\.


--
-- Data for Name: tbl_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_category (id, category_name, image) FROM stdin;
5	Kids	uploads/2024-11-18_165426.307090.jpg
2	Books	uploads/2024-11-18_165431.975954.jpg
4	Fiction	uploads/2024-11-18_165438.193461.jpg
1	eBooks	uploads/2024-11-18_165503.615884.jpg
\.


--
-- Data for Name: tbl_favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_favorites (id, customer_id, product_id, favorite) FROM stdin;
16	19	5	t
17	19	6	t
19	17	5	t
20	19	16	t
21	19	7	t
22	20	14	t
23	20	9	t
\.


--
-- Data for Name: tbl_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_order (ord_id, customer_id, customer_name, device_id, payment_type, status_id, seller, discount, total_amount, address_id) FROM stdin;
54	17	test	c8BNctjlRB2m1JPqX3kjR-:APA91bGrQ8SpSTsHDPpmEXSwOsCMwvGnM1szMDiZ8SabRpQVo5Oe_0whlVS1vUgJbzzOyAXHY9TG3MrP_yG_zs66f-z1_LbpLuG1K_nLvUexgqA4M1AkSpc	Cash On Delivery	4	customer	0	6	12
55	19	sokon	cUxGGEHFQfukQ7A1-RayXu:APA91bGCYgx0PRsLyP7wfzO8KiI-Xw3NUFwr3b6ApS96_uw1AFZp97P0JI8Me6G24macsY4P--vrmHyP1dlWFY5Ni43Wuh7y7ZvdTDWoLhXK434p0xBkNXA	Credit / Debit Card	4	customer	0	6	13
72	19	sokon	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	4	customer	0	28	13
69	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	2	customer	0	41.99	12
59	19	sokon	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	4	customer	0	81.98	13
67	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	2	customer	0	81.98	12
71	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	5	customer	0	81.98	12
57	19	sokon	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	4	customer	0	40	13
56	19	sokon	cUxGGEHFQfukQ7A1-RayXu:APA91bGCYgx0PRsLyP7wfzO8KiI-Xw3NUFwr3b6ApS96_uw1AFZp97P0JI8Me6G24macsY4P--vrmHyP1dlWFY5Ni43Wuh7y7ZvdTDWoLhXK434p0xBkNXA	Cash On Delivery	2	customer	0	10	13
60	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Credit / Debit Card	1	customer	0	41.99	12
61	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	41.99	12
62	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	41.99	12
63	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	81.98	12
64	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	81.98	12
65	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	81.98	12
66	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	1	customer	0	81.98	12
68	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	5	customer	0	41.99	12
58	17	test	cNgmyAr6T-OIVcj972e3al:APA91bHJLKspIvc3K3TRNjwze_u_UIXgazOflhg0Rx08NEw1MtLJ4MhhR4f7dcFzakjw_ssngmPk0_nORzhiQnFs1PYcz5jnUQYmJoEWq80nHka3f4C7KQQ	Cash On Delivery	4	customer	0	41.99	14
73	19	sokon	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	5	customer	0	26	13
70	17	test	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Credit / Debit Card	4	customer	0	81.98	12
75	20	Rum	e38aYDk1S1WLKefMqf-jEU:APA91bF-IeSGZ9FNphAlv-NqdujtRCCLhN5zRdCOCGUmKTqlA64E-_MNMCmH8v454xUnt_GIoGPZIgU7fSX2rhX0Pv43MMJk9zebiDMxXtEBPJF_5VkRay0	Cash On Delivery	4	customer	0	143.99	15
74	19	sokon	fXhDt6wLStC0z5dMzvF_4r:APA91bF007_pBnNHo500b8NzQOT3njuIaSLuCPQlCFRtl1xjYNuDHr8YBDYmXhAlywv_n_ZNhlEkXSZqSRTw0iONnktdkOxoT10zZ37dCa4YkzJ5rqKMMjc	Cash On Delivery	2	customer	0	25.99	13
76	20	Rum	e38aYDk1S1WLKefMqf-jEU:APA91bF-IeSGZ9FNphAlv-NqdujtRCCLhN5zRdCOCGUmKTqlA64E-_MNMCmH8v454xUnt_GIoGPZIgU7fSX2rhX0Pv43MMJk9zebiDMxXtEBPJF_5VkRay0	Cash On Delivery	5	customer	0	34	15
77	20	Rum	e38aYDk1S1WLKefMqf-jEU:APA91bF-IeSGZ9FNphAlv-NqdujtRCCLhN5zRdCOCGUmKTqlA64E-_MNMCmH8v454xUnt_GIoGPZIgU7fSX2rhX0Pv43MMJk9zebiDMxXtEBPJF_5VkRay0	Cash On Delivery	1	customer	0	38.99	15
\.


--
-- Data for Name: tbl_order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_order_detail (ord_id, product_id, qty, amount, order_date) FROM stdin;
72	8	1	26	19/Nov/2024 06:20 PM
73	16	1	24	19/Nov/2024 06:21 PM
74	12	1	23.99	19/Nov/2024 06:21 PM
75	14	2	90	19/Nov/2024 06:25 PM
75	9	1	19.99	19/Nov/2024 06:25 PM
75	10	1	32	19/Nov/2024 06:25 PM
76	10	1	32	19/Nov/2024 06:25 PM
77	13	1	36.99	20/Nov/2024 05:37 PM
\.


--
-- Data for Name: tbl_order_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_order_status (id, status) FROM stdin;
1	Pending
2	Processing
3	Delivering
4	Completed
5	Cancelled
\.


--
-- Data for Name: tbl_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_product (product_id, product_name, qty, "desc", image, sold, price_in, price_out, favid, category_id) FROM stdin;
10	Onyx Storm (Deluxe Limited Edition)	13	\N	uploads/2024-11-18_161634.413491.jpg	2	30	32	\N	1
13	Five Broken Blades (Deluxe Limited Edition)	4	\N	uploads/2024-11-18_162923.998005.jpg	1	25	36.99	\N	4
7	Ours: A Novel	32	\N	uploads/2024-11-18_161726.562389.jpg	\N	20	32	\N	2
6	James (2024 B&N Book of the Year)	20	\N	uploads/2024-11-18_161603.516289.jpg	\N	22	24.99	\N	2
15	Alas de hierro (Empíreo 2) Edición coleccionista enriquecida y limitada / Iron Flameby Rebecca Yarros	12	\N	uploads/2024-11-18_163108.102662.jpg	\N	25	45	\N	4
8	Mutiny	15	\N	uploads/2024-11-18_161749.886553.jpg	1	20	26	\N	1
16	Soul School: Taking Kids on a Joy-Filled Journey Through the Heart of Black American Culture	24	\N	uploads/2024-11-18_163224.820407.jpg	1	12	24	\N	5
12	The Hurricane Wars: A Novel	11	\N	uploads/2024-11-18_162330.811793.jpg	1	15	23.99	\N	1
14	Alas de sangre (Empíreo 1) Edición coleccionista enriquecida y limitada / Fourth Wing	1	\N	uploads/2024-11-18_163034.393152.jpg	2	25	45	\N	4
9	Skyshade	15	\N	uploads/2024-11-18_161822.825861.jpg	1	12	19.99	\N	2
\.


--
-- Data for Name: tbl_sale_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_sale_report (id, customer_name, units, payment_type, amount_sale, date) FROM stdin;
1	admin	2	Cash On Delivery	6.00	2024-11-14 19:42:00
2	tester	2	Cash On Delivery	10.00	2024-11-15 17:39:00
3	test	1	Cash On Delivery	6.00	2024-11-16 15:15:00
4	sokon	1	Credit / Debit Card	6.00	2024-11-17 08:57:00
5	sokon	2	Cash On Delivery	10.00	2024-11-17 08:57:00
6	sokon	1	Cash On Delivery	40.00	2024-11-18 16:13:00
7	test	1	Cash On Delivery	41.99	2024-11-18 16:37:00
8	sokon	2	Cash On Delivery	81.98	2024-11-18 16:45:00
\.


--
-- Data for Name: tbl_slides; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_slides (id, title, image) FROM stdin;
2		uploads/2024-11-18_164922.589484.jpg
4		uploads/2024-11-18_164944.899442.jpg
3		uploads/2024-11-18_165049.963117.jpg
\.


--
-- Data for Name: tbl_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_user (id, name, email, phone, is_admin, active, password, photo, created_at, updated_at, token) FROM stdin;
1	admin	admin@gmail.com	0974278786	t	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3		2024-11-12 13:14:41.341914	2024-11-17 11:31:50.883239	c08de1a74e1b8f1853738ec243e9405a
17	test	test@gmail.com	test	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	uploads/2024-11-16_150426.094503.jpg	2024-11-15 15:50:08.910847	2024-11-18 17:34:07.558556	d8d0d23833e43ab717ce22bae536ba81
18	tester	nea@gmail.com	098	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3		2024-11-15 16:01:37.392452	2024-11-17 13:48:36.113069	375b86d7304e6a97046d333cc6ea56ae
19	sokon	sokon@gmail.com	0968006877	f	t	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	uploads/2024-11-19_181822.184154.jpg	2024-11-17 09:56:14.399386	2024-11-19 19:18:24.724081	083b32dabe3cea6b9248947032701b5a
20	Rum	rumuzu24@gmail.com	089828163	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	uploads/2024-11-18_163528.810971.jpg	2024-11-18 17:29:40.814664	2024-11-19 20:25:28.536415	dcffe43314fc1f12b9ea2a3010ea83e2
\.


--
-- Name: tbl_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_address_id_seq', 15, true);


--
-- Name: tbl_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_category_id_seq', 6, true);


--
-- Name: tbl_favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_favorites_id_seq', 23, true);


--
-- Name: tbl_order_ord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_order_ord_id_seq', 77, true);


--
-- Name: tbl_order_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_order_status_id_seq', 1, false);


--
-- Name: tbl_product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_product_product_id_seq', 16, true);


--
-- Name: tbl_sale_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sale_report_id_seq', 12, true);


--
-- Name: tbl_slides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_slides_id_seq', 4, true);


--
-- Name: tbl_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_user_id_seq', 20, true);


--
-- Name: tbl_address tbl_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_address
    ADD CONSTRAINT tbl_address_pkey PRIMARY KEY (id);


--
-- Name: tbl_category tbl_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_category
    ADD CONSTRAINT tbl_category_pkey PRIMARY KEY (id);


--
-- Name: tbl_favorites tbl_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_favorites
    ADD CONSTRAINT tbl_favorites_pkey PRIMARY KEY (id);


--
-- Name: tbl_order_detail tbl_order_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order_detail
    ADD CONSTRAINT tbl_order_detail_pkey PRIMARY KEY (ord_id, product_id);


--
-- Name: tbl_order tbl_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order
    ADD CONSTRAINT tbl_order_pkey PRIMARY KEY (ord_id);


--
-- Name: tbl_order_status tbl_order_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order_status
    ADD CONSTRAINT tbl_order_status_pkey PRIMARY KEY (id);


--
-- Name: tbl_product tbl_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_product
    ADD CONSTRAINT tbl_product_pkey PRIMARY KEY (product_id);


--
-- Name: tbl_sale_report tbl_sale_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_sale_report
    ADD CONSTRAINT tbl_sale_report_pkey PRIMARY KEY (id);


--
-- Name: tbl_slides tbl_slides_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_slides
    ADD CONSTRAINT tbl_slides_pkey PRIMARY KEY (id);


--
-- Name: tbl_user tbl_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_user
    ADD CONSTRAINT tbl_user_email_key UNIQUE (email);


--
-- Name: tbl_user tbl_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_user
    ADD CONSTRAINT tbl_user_pkey PRIMARY KEY (id);


--
-- Name: tbl_order tbl_order_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order
    ADD CONSTRAINT tbl_order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.tbl_address(id);


--
-- Name: tbl_order_detail tbl_order_detail_ord_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order_detail
    ADD CONSTRAINT tbl_order_detail_ord_id_fkey FOREIGN KEY (ord_id) REFERENCES public.tbl_order(ord_id);


--
-- Name: tbl_order_detail tbl_order_detail_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order_detail
    ADD CONSTRAINT tbl_order_detail_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.tbl_product(product_id) ON DELETE CASCADE;


--
-- Name: tbl_order tbl_order_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_order
    ADD CONSTRAINT tbl_order_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.tbl_order_status(id);


--
-- Name: tbl_product tbl_product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tbl_product
    ADD CONSTRAINT tbl_product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.tbl_category(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

