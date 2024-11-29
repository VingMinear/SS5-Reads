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
    house character varying(100),
    is_delete boolean DEFAULT false
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

COPY public.tbl_address (id, customer_id, latlng, receiver_name, phone_number, province, district, commune, house, is_delete) FROM stdin;
2	1	(37.4219983,-122.084)	nea	0974278786	ratanakiri	banlung	banlung	store	f
6	1	(37.4219983,-122.084)	aba	123	123	123			f
7	18	(37.4219983,-122.084)	nes	123123	rtk	banlung			f
13	19	(11.569563004287103,104.90264560955421)	sokon	0968006877	Phnom penh	veal sbov	kdey takoy	1	f
15	20	(11.567986,104.8946644)	Sovan Rum	+85510630676	Phnom Penh	Khan Tuol Kork	No. 86A		f
16	\N	(11.569563004287103,104.90264560955421)	a	123	rtk	123			f
14	17	(11.5679879,104.8946664)	panha rith	0973813584	pp	tk		my house	f
18	17	(11.569563004287103,104.90264560955421)	asd	123654789	pp	dp			t
19	21	(11.5392879,104.9705366)	lundy	09768453	Phnom Penh	Chbar Ampov	GXQ8+3XJ	12	f
20	22	(11.569563004287103,104.90264560955421)	ss5	098765432	Phnom penh	chbar ampov	Peng hout	12	f
21	22	(11.569563004287103,104.90264560955421)	sokon	098765432	Kandal	Keansvay			f
\.


--
-- Data for Name: tbl_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_category (id, category_name, image) FROM stdin;
5	Kids	uploads/933a36aba21155a9264fbd8c3da49659.jpg
4	Fiction	uploads/8132468.jpg
1	eBooks	uploads/5253158.jpg
2	Books	uploads/8832880.jpg
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
30	21	12	t
33	22	14	t
\.


--
-- Data for Name: tbl_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_order (ord_id, customer_id, customer_name, device_id, payment_type, status_id, seller, discount, total_amount, address_id) FROM stdin;
82	17	test		Cash On Delivery	4	customer	0	266.96	\N
83	17	nea		Cash On Delivery	4	customer	0	26	14
84	17	nea		Cash On Delivery	4	customer	0	34	14
85	21	lundy	eaKutw35R-eCAmZE8GUuNI:APA91bF8Gt1hf9p4-VP7oCBgnuIKybLbujfwB9lJlfa4OrT-jt-3xJPwMTRvKDzvZhFs00WZUaW_3ZQsL3g3FEjdd8GZnmCYlD5HSBxbkm2M1Ty-Rn4SwBc	Cash On Delivery	1	customer	0	77.97999999999999	19
86	21	lundy	eaKutw35R-eCAmZE8GUuNI:APA91bF8Gt1hf9p4-VP7oCBgnuIKybLbujfwB9lJlfa4OrT-jt-3xJPwMTRvKDzvZhFs00WZUaW_3ZQsL3g3FEjdd8GZnmCYlD5HSBxbkm2M1Ty-Rn4SwBc	Credit / Debit Card	1	customer	0	38.99	19
87	19	sokon		Cash On Delivery	1	customer	0	51	13
88	22	SS5 Final		Cash On Delivery	4	customer	0	49	20
89	22	SS5 Final		Credit / Debit Card	5	customer	0	84	21
90	22	SS5 Final		Cash On Delivery	1	customer	0	2	20
\.


--
-- Data for Name: tbl_order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_order_detail (ord_id, product_id, qty, amount, order_date) FROM stdin;
82	6	1	24.99	25/Nov/2024 04:09 PM
82	7	1	32	25/Nov/2024 04:09 PM
82	8	1	26	25/Nov/2024 04:09 PM
82	9	1	19.99	25/Nov/2024 04:09 PM
82	10	1	32	25/Nov/2024 04:09 PM
82	12	1	23.99	25/Nov/2024 04:09 PM
82	16	1	24	25/Nov/2024 04:09 PM
82	15	1	45	25/Nov/2024 04:09 PM
82	13	1	36.99	25/Nov/2024 04:09 PM
83	16	1	24	26/Nov/2024 01:01 AM
84	10	1	32	26/Nov/2024 09:37 AM
85	10	1	32	26/Nov/2024 12:57 PM
85	12	1	23.99	26/Nov/2024 12:57 PM
85	9	1	19.99	26/Nov/2024 12:57 PM
86	13	1	36.99	26/Nov/2024 12:58 PM
87	12	1	23	26/Nov/2024 01:24 PM
87	8	1	26	26/Nov/2024 01:24 PM
88	16	1	24	26/Nov/2024 03:06 PM
88	12	1	23	26/Nov/2024 03:06 PM
89	16	1	24	26/Nov/2024 03:08 PM
89	10	1	32	26/Nov/2024 03:08 PM
89	8	1	26	26/Nov/2024 03:08 PM
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
14	Alas de sangre (Empíreo 1) Edición coleccionista enriquecida y limitada / Fourth Wing	10	Bestseller No. 1 del New York Times • Mejores libros del año de Amazon, No. 4 • Mejores libros del año de Apple • Mejor libro de fantasía de Barnes & Noble • Premio Goodreads Choice, semifinalista	uploads/9786073916240_p0_v2_s600x595.jpg	3	25	45	\N	4
7	Ours: A Novel	30	Chosen as a Most Anticipated Book of 2024 by Oprah’s Book Club, Elle, Reader’s Digest, The Rumpus, Kirkus Reviews, The Millions, Lit Hub, and more	uploads/9780593654828_p0_v2_s600x595.jpg	2	20	32	\N	2
15	Alas de hierro (Empíreo 2) Edición coleccionista enriquecida y limitada / Iron Flameby Rebecca Yarros	12	Los mejores libros del año de Amazon, n.° 4 • Los mejores libros del año de Apple • Mejor libro de fantasía de 2023 de Barnes & Noble • Premio Goodreads Choice, semifinalista • Libros favoritos de 2023 de Newsweek 	uploads/9786073916257_p0_v2_s600x595.jpg	2	25	45	\N	4
13	Five Broken Blades (Deluxe Limited Edition)	12		uploads/9781649376909_p0_v4_s600x595.jpg	4	25	36	\N	4
9	Skyshade	12	The latest installment in the hit fantasy series brings higher stakes and deadlier matters of the heart 	uploads/9781419780974_p0_v2_s1200x1200.jpg	4	12	19	\N	2
12	The Hurricane Wars: A Novel	6		uploads/9781502725899_p0_v2_s1200x1200.jpg	6	15	23	\N	1
16	Soul School: Taking Kids on a Joy-Filled Journey Through the Heart of Black American Culture	19	A must-have addition to the shelf for any parent hoping to introduce more inclusive books into the home, with 100+ essential titles for early readers through high school	uploads/9780593716823_p0_v2_s1200x1200.jpg	6	12	24	\N	5
10	Onyx Storm (Deluxe Limited Edition)	6	The shocking ending to Iron Flame left us with a dizzying need for the third installment of Yarros’ phenomenal series. With love gained and lost, battles waged and won — Onyx Storm is another razor-sharp ride on dragon back.	uploads/9781649374189_p0_v8_s1200x1200.jpg	9	30	32	\N	1
8	Mutiny	11		uploads/9780143136934_p0_v4_s1200x1200.jpg	5	20	26	\N	1
17	Test	12	Hello	uploads/9780062863102_p0_v3_s1200x1200.jpg	\N	12	15	\N	5
6	James (2024 B&N Book of the Year)	18	A powerful story of family, home and freedom. Percival Everett has flipped the script on an American classic as Huck Finn steps to the side and Jim — James — takes center stage	uploads/9780385550369_p0_v3_s1200x1200.jpg	2	22	24	\N	2
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
2		uploads/book-banner-ad-template-design-369952ddd08de78a01481898e6bb35b1_screen.jpg
4		uploads/banner.jpg
3		uploads/banner2.jpg
\.


--
-- Data for Name: tbl_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tbl_user (id, name, email, phone, is_admin, active, password, photo, created_at, updated_at, token) FROM stdin;
18	tester	nea@gmail.com	098	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3		2024-11-15 16:01:37.392452	2024-11-17 13:48:36.113069	9a74ea8cdc25d68e48ca14fc5aec4b52
20	Rum	rumuzu24@gmail.com	089828163	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	uploads/2024-11-18_163528.810971.jpg	2024-11-18 17:29:40.814664	2024-11-26 16:16:03.306587	dcffe43314fc1f12b9ea2a3010ea83e2
22	SS5 Final	ss5final@gmail.com	098765432	f	t	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	uploads/26944f16fe09649616becb4f91bcb41f.jpg	2024-11-26 15:58:26.606819	2024-11-26 16:16:23.321767	cde482bc8ad9e6828efbe19dbaa833d2
17	nea	test@gmail.com	0974278786	f	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	uploads/photo_2023-06-12_21-47-31.jpg	2024-11-15 15:50:08.910847	2024-11-25 23:57:24.004523	e92070dc2d02d3f948686d1f6c68347b
1	admin	admin@gmail.com	0974278786	t	t	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3		2024-11-12 13:14:41.341914	2024-11-17 11:31:50.883239	96dfa23081352517fdad5fc627fa1466
21	lundy12	lundy1@gmail.com	0786453	f	t	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	uploads/2024-11-26_130204.177712.jpg	2024-11-26 13:56:01.062481	2024-11-26 14:02:26.281663	310689dd4f5cb81410a2aab183bd3696
19	sokon	sokon@gmail.com	0968006877	f	t	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	uploads/2024-11-19_181822.184154.jpg	2024-11-17 09:56:14.399386	2024-11-19 19:18:24.724081	ce31676fee109beeb0e2ddcb5a600b96
\.


--
-- Name: tbl_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_address_id_seq', 21, true);


--
-- Name: tbl_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_category_id_seq', 7, true);


--
-- Name: tbl_favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_favorites_id_seq', 33, true);


--
-- Name: tbl_order_ord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_order_ord_id_seq', 90, true);


--
-- Name: tbl_order_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_order_status_id_seq', 1, false);


--
-- Name: tbl_product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_product_product_id_seq', 17, true);


--
-- Name: tbl_sale_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_sale_report_id_seq', 12, true);


--
-- Name: tbl_slides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_slides_id_seq', 5, true);


--
-- Name: tbl_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tbl_user_id_seq', 22, true);


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
    ADD CONSTRAINT tbl_order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.tbl_address(id) ON DELETE SET NULL;


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

