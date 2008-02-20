# -*- coding: utf-8 -*-

cdef enum bool:
    false = 0
    true = 1

cdef extern from "stdio.h":
    struct FILE:
        pass

cdef extern from "config.h":
    ctypedef long size_t

cdef extern from "common.h":

    ## From "recode.h"

    # Published (opaque) typedefs.

    struct recode_outer:
        pass
    struct recode_request:
        pass
    struct recode_task:
        pass
    struct recode_symbol:
        pass
    ctypedef recode_outer *RECODE_OUTER
    ctypedef recode_request *RECODE_REQUEST
    ctypedef recode_task *RECODE_TASK
    ctypedef recode_request *RECODE_CONST_REQUEST
    ctypedef recode_symbol *RECODE_CONST_SYMBOL

    # Description of list formats.

    enum recode_list_format:
        RECODE_NO_FORMAT
        RECODE_DECIMAL_FORMAT
        RECODE_OCTAL_FORMAT
        RECODE_HEXADECIMAL_FORMAT
        RECODE_FULL_FORMAT

    # Description of programming languages.

    enum recode_programming_language:
        RECODE_NO_LANGUAGE
        RECODE_LANGUAGE_C
        RECODE_LANGUAGE_PERL

    # Recode library at OUTER level.

    RECODE_OUTER recode_new_outer(bool)
    bool recode_delete_outer(RECODE_OUTER)
    bool list_all_symbols(RECODE_OUTER, RECODE_CONST_SYMBOL)
    bool list_concise_charset(
            RECODE_OUTER, RECODE_CONST_SYMBOL, recode_list_format)
    bool list_full_charset(RECODE_OUTER, RECODE_CONST_SYMBOL)

    # Recode library at REQUEST level.

    RECODE_REQUEST recode_new_request(RECODE_OUTER)
    bool recode_delete_request(RECODE_REQUEST)
    bool recode_scan_request(RECODE_REQUEST, char *)
    bool recode_format_table(
            RECODE_REQUEST, recode_programming_language, char *)
    char *recode_string(RECODE_CONST_REQUEST, char *)
    bool recode_string_to_buffer(
            RECODE_CONST_REQUEST, char *, char **, size_t *, size_t *)
    bool recode_string_to_file(
            RECODE_CONST_REQUEST, char *, FILE *)
    bool recode_buffer_to_buffer(
            RECODE_CONST_REQUEST, char *, size_t, char **, size_t *, size_t *)
    bool recode_buffer_to_file(
            RECODE_CONST_REQUEST, char *, size_t, FILE *)
    bool recode_file_to_buffer(
            RECODE_CONST_REQUEST, FILE *, char **, size_t *, size_t *)
    bool recode_file_to_file(RECODE_CONST_REQUEST, FILE *, FILE *)

    # Recode library at TASK level.

    RECODE_TASK recode_new_task(RECODE_CONST_REQUEST)
    bool recode_delete_task(RECODE_TASK)
    bool recode_perform_task(RECODE_TASK)

    ## From "recodext.h"

    #/* Internal typedefs, to supplement those in "recode.h".  */
    #
    #typedef struct recode_symbol *                     RECODE_SYMBOL;
    #typedef struct recode_option_list *                RECODE_OPTION_LIST;
    #typedef struct recode_single *                     RECODE_SINGLE;
    #typedef struct recode_step *                       RECODE_STEP;
    #typedef struct recode_alias *                      RECODE_ALIAS;
    #typedef struct recode_subtask *                    RECODE_SUBTASK;
    #
    #typedef const struct recode_option_list *  RECODE_CONST_OPTION_LIST;
    #typedef const struct recode_outer *                RECODE_CONST_OUTER;
    #typedef const struct recode_step *         RECODE_CONST_STEP;
    #typedef const struct recode_alias *                RECODE_CONST_ALIAS;
    #typedef const struct recode_task *         RECODE_CONST_TASK;
    #
    #/*---------------------------------------------------------.
    #| Maintain maximum of ERROR and current error in SUBTASK.  |
    #`---------------------------------------------------------*/
    #
    ##define SET_SUBTASK_ERROR(Error, Subtask) \
    #  recode_if_nogo (Error, Subtask)
    #
    #/*--------------------------------------------------------------------------.
    #| Return from SUBTASK with `false', if the failure level has been reached.  |
    #`--------------------------------------------------------------------------*/
    #
    ##define SUBTASK_RETURN(Subtask) \
    #  return (Subtask)->task->error_so_far < (Subtask)->task->fail_level
    #
    #/*-------------------------------------------------------------------------.
    #| Maintain maximum of ERROR and current error in SUBTASK.  If the abort    |
    #| level has been reached, then return immediately as with SUBTASK_RETURN.  |
    #`-------------------------------------------------------------------------*/
    #
    ##define RETURN_IF_NOGO(Error, Subtask) \
    #  do {                                                             \
    #    if (recode_if_nogo (Error, Subtask))                   \
    #       SUBTASK_RETURN (Subtask);                           \
    #  } while (false)
    #
    #/* Various structure declarations.  */
    #
    #/*-----------------------------------------.
    #| Outer variables for the recode library.  |
    #`-----------------------------------------*/
    #
    #/* Error codes, in increasing severity.  */
    #
    #enum recode_error
    #  {
    #    RECODE_NO_ERROR,               /* no error so far */
    #    RECODE_NOT_CANONICAL,  /* input is not exact, but equivalent */
    #    RECODE_AMBIGUOUS_OUTPUT,       /* output will be misleading */
    #    RECODE_UNTRANSLATABLE, /* input is getting lost, while valid */
    #    RECODE_INVALID_INPUT,  /* input is getting lost, but was invalid */
    #    RECODE_SYSTEM_ERROR,   /* system returned input/output failure */
    #    RECODE_USER_ERROR,             /* library is being misused */
    #    RECODE_INTERNAL_ERROR, /* programming botch in the library */
    #    RECODE_MAXIMUM_ERROR   /* impossible value (should be kept last) */
    #  };
    #
    #/* Structure for relating alias names to charsets and surfaces.  */
    #
    #struct recode_alias
    #  {
    #    const char *name;              /* charset, surface or alias name */
    #    RECODE_SYMBOL symbol;  /* associated symbol */
    #    /* If a charset, list of surfaces usually applied by default.  */
    #    struct recode_surface_list *implied_surfaces;
    #  };
    #
    #/* The sole purpose of qualities is for later attributing step costs.  */
    #
    #enum recode_size
    #  {
    #    RECODE_1,                      /* roughly one byte per character */
    #    RECODE_2,                      /* roughly two bytes per character */
    #    RECODE_4,                      /* roughly four bytes per character */
    #    RECODE_N                       /* variable number of bytes per character */
    #  };
    #
    #struct recode_quality
    #  {
    #    enum recode_size in_size : 3; /* rough byte size of input characters */
    #    enum recode_size out_size : 3; /* rough byte size of output characters */
    #    bool reversible : 1;   /* transformation is known to be reversible */
    #    bool slower : 1;               /* transformation is slower than average */
    #    bool faster : 1;               /* transformation is faster than average */
    #  };
    #
    #/* Main variables of the initialised library.  */
    #
    #struct recode_outer
    #  {
    #    /* This flag asks the library to diagnose and abort itself if errors.  */
    #    bool auto_abort;
    #
    #    /* If new steps should automatically have reversibility for fallback.  */
    #    bool auto_reversibility;
    #
    #    /* charset.c */
    #    /* --------- */
    #
    #    /* Known pairs (for restricting listing).  */
    #    struct recode_known_pair *pair_restriction;
    #    unsigned pair_restrictions;
    #
    #    /* Opaque Hash_table pointer giving access to the single table holding all
    #       names and aliases for charsets, surfaces and fallback methods.  */
    #    void *alias_table;
    #
    #    /* Unique symbols are linked into a list and counted.  */
    #    RECODE_SYMBOL symbol_list;
    #    unsigned number_of_symbols;
    #
    #    /* Arrays of strings ready for argmatch.  */
    #    char **argmatch_charset_array;
    #    char **argmatch_surface_array;
    #    const char **realname_charset_array;
    #    const char **realname_surface_array;
    #
    #    /* recode.c */
    #    /* -------- */
    #
    #    /* Known single steps.  */
    #    struct recode_single *single_list;
    #    unsigned number_of_singles;
    #
    #    /* Identity recoding table.  */
    #    const unsigned char *one_to_same;
    #
    #    /* Preset charsets and surfaces.  */
    #    RECODE_SYMBOL data_symbol;/* special charset defining surfaces */
    #    RECODE_SYMBOL tree_symbol; /* special charset defining structures */
    #    RECODE_SYMBOL ucs2_charset; /* UCS-2 */
    #    RECODE_SYMBOL libiconv_pivot; /* `libiconv' internal UCS */
    #    RECODE_SYMBOL crlf_surface; /* for IBM PC machines */
    #    RECODE_SYMBOL cr_surface;      /* for Macintosh machines */
    #
    #    /* Preset qualities, to make step initialisation simpler.  */
    #    struct recode_quality quality_byte_reversible;
    #    struct recode_quality quality_byte_to_byte;
    #    struct recode_quality quality_byte_to_ucs2;
    #    struct recode_quality quality_byte_to_variable;
    #    struct recode_quality quality_ucs2_to_byte;
    #    struct recode_quality quality_ucs2_to_variable;
    #    struct recode_quality quality_variable_to_byte;
    #    struct recode_quality quality_variable_to_ucs2;
    #    struct recode_quality quality_variable_to_variable;
    #  };
    #
    #/*--------------------------.
    #| Description of a symbol.  |
    #`--------------------------*/
    #
    #enum recode_symbol_type
    #  {
    #    RECODE_NO_SYMBOL_TYPE, /* missing value */
    #    RECODE_CHARSET,                /* visible in the space of charsets */
    #    RECODE_DATA_SURFACE,   /* this is a mere data surface */
    #    RECODE_TREE_SURFACE            /* this is a structural surface */
    #  };
    #
    #enum recode_data_type
    #  {
    #    RECODE_NO_CHARSET_DATA,        /* the charset_table field is unused */
    #    RECODE_STRIP_DATA,             /* pool pointer and array of strips */
    #    RECODE_EXPLODE_DATA            /* explode variable length data */
    #  };
    #
    #struct recode_symbol
    #  {
    #    /* Chaining of all known symbols (charsets and surfaces).  */
    #    RECODE_SYMBOL next;
    #
    #    /* Unique ordinal for this symbol, counted from zero.  */
    #    unsigned ordinal;
    #
    #    /* Main name.  */
    #    const char *name;
    #
    #    /* Type of table.  */
    #    enum recode_data_type data_type;
    #
    #    /* Recoding table.  */
    #    void *data;
    #
    #    /* Step for data..CHARSET transformation, if any, or NULL.  */
    #    struct recode_single *resurfacer;
    #
    #    /* Step for CHARSET..data transformation, if any, or NULL.  */
    #    struct recode_single *unsurfacer;
    #
    #    /* Non zero if this is an acceptable charset (not only a surface).  */
    #    enum recode_symbol_type type : 3;
    #
    #    /* Non zero if this one should be ignored.  */
    #    bool ignore : 2;
    #  };
    #
    #struct recode_surface_list
    #  {
    #    RECODE_CONST_SYMBOL surface;
    #    struct recode_surface_list *next;
    #  };
    #
    #/*-------------------------------------------.
    #| Description of a single step of recoding.  |
    #`-------------------------------------------*/
    #
    #typedef bool (*Recode_init) PARAMS ((RECODE_STEP, RECODE_CONST_REQUEST,
    #                                RECODE_CONST_OPTION_LIST,
    #                                RECODE_CONST_OPTION_LIST));
    #typedef bool (*Recode_term) PARAMS ((RECODE_STEP, RECODE_CONST_REQUEST));
    #typedef bool (*Recode_transform) PARAMS ((RECODE_SUBTASK));
    #typedef bool (*Recode_fallback) PARAMS ((RECODE_SUBTASK, unsigned));
    #
    #/* The `single' structure holds data needed to decide of sequences, and is
    #   invariant over actual requests.  The `step' structure holds data needed for
    #   task execution, it may take care of fallback and option variance.  */
    #
    #struct recode_single
    #  {
    #    /* Chaining of all known single steps.  */
    #    struct recode_single *next;
    #
    #    /* Charset before conversion.  */
    #    RECODE_SYMBOL before;
    #
    #    /* Charset after conversion.  */
    #    RECODE_SYMBOL after;
    #
    #    /* Cost for this single step only.  */
    #    short conversion_cost;
    #
    #    /* Initial value for step_table.  */
    #    void *initial_step_table;
    #
    #    /* Recoding quality.  */
    #    struct recode_quality quality;
    #
    #    /* Initialisation handler, to be called before step optimisation.  */
    #    Recode_init init_routine;
    #
    #    /* Transformation handler, for doing the actual recoding work.  */
    #    Recode_transform transform_routine;
    #
    #    /* Default fallback for the step.  Merely to implement `-s' option.  */
    #    Recode_fallback fallback_routine;
    #  };
    #
    #enum recode_step_type
    #  {
    #    RECODE_NO_STEP_TABLE,  /* the step_table field is unused */
    #    RECODE_BYTE_TO_BYTE,   /* array of 256 bytes */
    #    RECODE_BYTE_TO_STRING, /* array of 256 strings */
    #    RECODE_UCS2_TO_BYTE,   /* hash from ucs2 to byte */
    #    RECODE_UCS2_TO_STRING, /* hash from ucs2 to string */
    #    RECODE_STRING_TO_UCS2, /* hash from ucs2 to string, reversed */
    #    RECODE_COMBINE_EXPLODE,        /* raw data for combining or exploding */
    #    RECODE_COMBINE_STEP,   /* special hash for combining */
    #    RECODE_EXPLODE_STEP            /* special hash for exploding */
    #  };
    #
    #struct recode_step
    #  {
    #    /* Charset before conversion.  */
    #    RECODE_SYMBOL before;
    #
    #    /* Charset after conversion.  */
    #    RECODE_SYMBOL after;
    #
    #    /* Recoding quality.  */
    #    struct recode_quality quality;
    #
    #    /* Type of table.  */
    #    enum recode_step_type step_type;
    #
    #    /* Recoding table.  */
    #    void *step_table;
    #
    #    /* Step specific variables.  */
    #    void *local;
    #
    #    /* Transformation handler, for doing the actual recoding work.  */
    #    Recode_transform transform_routine;
    #
    #    /* Fallback for the step.  */
    #    Recode_fallback fallback_routine;
    #
    #    /* Cleanup handler, to be called after the recoding is done.  */
    #    Recode_term term_routine;
    #  };
    #
    #struct recode_option_list
    #  {
    #    const char *option;
    #    RECODE_OPTION_LIST next;
    #  };
    #
    #/*------------------------------------------------------------------------.
    #| A recoding request holds, among other things, a selected path among the |
    #| available recoding steps, it so represents a kind of recoding plan.     |
    #`------------------------------------------------------------------------*/
    #
    #struct recode_request
    #  {
    #    /* A request is always associated with a recoding system.  */
    #    RECODE_OUTER outer;
    #
    #    /* By setting the following flag, the program will echo to stderr the
    #       sequence of elementary recoding steps needed to achieve the requested
    #       recoding.  */
    #    bool verbose_flag : 1;
    #
    #    /* In `texte' charset, some countries use double quotes to mark diaeresis,
    #       while some other prefer colons.  This field contains the diaeresis
    #       character for `texte' charset.  Nominally set to a double quote, it can
    #       be forced to a colon.  Those are the only two acceptable values.  */
    #    char diaeresis_char;
    #
    #    /* If producing a recoding table in source form, there will be no actual
    #       recoding done, and consequently, the optimisation of step sequence can
    #       be attempted more aggressively.  If the step sequence cannot be reduced
    #       to a single step, table production will fail.  */
    #    bool make_header_flag : 1;
    #
    #    /* For `latex' charset, it is often convenient to recode the diacritics
    #       only, while letting other LaTeX code using backslashes unrecoded.  In
    #       the other charset, one can edit text as well as LaTeX directives.  */
    #    bool diacritics_only : 1;
    #
    #    /* For `ibmpc' charset, characters 176 to 223 are use to draw boxes.  If
    #       this field is set, while getting out of `ibmpc', ASCII characters are
    #       selected so to approximate these boxes.  */
    #    bool ascii_graphics : 1;
    #
    #    /* Array stating the sequence of conversions.  */
    #    RECODE_STEP sequence_array;
    #    size_t sequence_allocated;
    #    short sequence_length;
    #
    #    /* Internal variables used while scanning request text.  */
    #    char *work_string;             /* buffer space for generated work strings */
    #    size_t work_string_length;     /* length of work_string */
    #    size_t work_string_allocated; /* allocated length of work_string */
    #    const char *scan_cursor;       /* next character to be seen */
    #    char *scanned_string;  /* buffer space to scan strings */
    #  };
    #
    #/*--------------------------------------------------------------------.
    #| A recoding text is either an external file or an in memory buffer.  |
    #`--------------------------------------------------------------------*/
    #
    #/* While the recoding is going on, FILE being non-NULL has precedence over
    #   BUFFER.  Moreover, if NAME is not NULL at start of recoding, this is
    #   interpreted as a request for the library to open the named file, either
    #   in read or write mode, and also to close it afterwards.  Standard input
    #   or output is denoted by NAME being non-NULL, but otherwise empty.
    #
    #   If FILE is NULL in input mode, the in-memory read-only text extends from
    #   BUFFER to LIMIT.  There is no clue about if the buffer has been allocated
    #   bigger.  When CURSOR reaches LIMIT, there is no more data to get.  If
    #   FILE is NULL in output mode, the in-memory text extends from BUFFER to
    #   CURSOR, but the buffer has been allocated until LIMIT.  When CURSOR
    #   reaches LIMIT, the buffer should be reallocated bigger, as needed.  */
    #
    #struct recode_read_only_text
    #  {
    #    const char *name;
    #    FILE *file;
    #    const char *buffer;
    #    const char *cursor;
    #    const char *limit;
    #  };
    #
    #struct recode_read_write_text
    #  {
    #    const char *name;
    #    FILE *file;
    #    char *buffer;
    #    char *cursor;
    #    char *limit;
    #  };
    #
    #/* Tells how various passes are interconnected.  */
    #
    #enum recode_sequence_strategy
    #  {
    #    RECODE_STRATEGY_UNDECIDED,     /* sequencing strategy is undecided yet */
    #    RECODE_SEQUENCE_IN_MEMORY,     /* keep intermediate recodings in memory */
    #    RECODE_SEQUENCE_WITH_FILES,    /* do not fork, use intermediate files */
    #    RECODE_SEQUENCE_WITH_PIPE      /* fork processes connected with `pipe(2)' */
    #  };
    #
    #/* Tells how to swap the incoming pair of bytes, while reading UCS-2.  */
    #
    #enum recode_swap_input
    #  {
    #    RECODE_SWAP_UNDECIDED, /* the text has not been read yet */
    #    RECODE_SWAP_NO,                /* no need to swap pair of bytes */
    #    RECODE_SWAP_YES                /* should swap incoming pair of bytes */
    #  };
    #
    #/*--------------------------------------------------------------------------.
    #| A recoding subtask associates a particular recoding step to a given input |
    #| text, for producing a corresponding output text.  It also holds error     |
    #| related statistics for the execution of that step.                        |
    #`--------------------------------------------------------------------------*/
    #
    #struct recode_subtask
    #  {
    #    /* Task for which this subtask is an element.  */
    #    RECODE_TASK task;
    #
    #    /* Step being executed by this subtask.  */
    #    RECODE_CONST_STEP step;
    #
    #    /* Current input and output.  */
    #    struct recode_read_only_text input;
    #    struct recode_read_write_text output;
    #
    #    /* Line count and character count in last line, both zero-based.  */
    #    unsigned newline_count;
    #    unsigned character_count;
    #  };
    #
    ##define GOT_CHARACTER(Subtask) \
    #  ((Subtask)->character_count++)
    #
    ##define GOT_NEWLINE(Subtask) \
    #  ((Subtask)->newline_count++, (Subtask)->character_count = 0)
    #
    #/*--------------------------------------------------------------------------.
    #| A recoding task associates a sequence of steps to a given input text, for |
    #| producing a corresponding output text.  It holds an array of subtasks.    |
    #`--------------------------------------------------------------------------*/
    #
    #struct recode_task
    #  {
    #    /* Associated request.  */
    #    RECODE_CONST_REQUEST request;
    #
    #    /* Initial input and final output.  */
    #    struct recode_read_only_text input;
    #    struct recode_read_write_text output;
    #
    #    /* Tells how various recoding steps (passes) will be interconnected.  */
    #    enum recode_sequence_strategy strategy : 3;
    #
    #    /* Produce a byte order mark on UCS-2 output, insist for it on input.  */
    #    bool byte_order_mark : 1;
    #
    #    /* The input UCS-2 stream might have bytes swapped (status variable).  */
    #    enum recode_swap_input swap_input : 3;
    #
    #    /* Error processing.  */
    #    /* -----------------  */
    #
    #    /* At this level, there will be failure.  */
    #    enum recode_error fail_level : 5;
    #
    #    /* At this level, task should be interrupted.  */
    #    enum recode_error abort_level : 5;
    #
    #    /* Maximum error level met so far (status variable).  */
    #    enum recode_error error_so_far : 5;
    #
    #    /* Step being executed when error_so_far was last set.  */
    #    RECODE_CONST_STEP error_at_step;
    #  };
    #
    #/* Specialities for some function arguments.  */
    #
    #/* For restricting charset lists.  */
    #
    #struct recode_known_pair
    #  {
    #    unsigned char left;            /* first character in pair */
    #    unsigned char right;   /* second character in pair */
    #  };
    #
    #/*----------------------.
    #| Various definitions.  |
    #`----------------------*/
    #
    #typedef unsigned short recode_ucs2;
    #
    #/* Double tables are generated as arrays of indices into a pool of strips,
    #   each strip holds STRIP_SIZE UCS-2 characters.  Some memory is saved by
    #   not allowing duplicate strips in the pool.  A smaller strip size yields
    #   more duplicates and so, a smaller pool, but then, tables get longer
    #   because more strip indices are needed for each table.  It is difficult to
    #   predict the optimal strip size.  Tests made on 1997-09-22 showed that a
    #   strip size of 4 needs 27808 bytes total, 8 needs 22656, 16 needs 23584
    #   and 32 needs 25568, so we decided to stick to a strip size of 8.  Change
    #   $STRIP_SIZE in `doc/tables.pl' if you change the value here.  */
    #
    #/* "Are we speaking slips, strips or bars?" (of gold press'latinum :-) */
    ##define STRIP_SIZE 8
    #
    #/* An struct strip_data is a pointer to a pool of strips, and an array
    #   of 256/STRIP_SIZE offsets for the start of strips into the pool, each strip
    #   describes STRIP_SIZE UCS-2 characters.  A missing character in a strip is
    #   indicated by all 16 bits set.  */
    #struct strip_data
    #  {
    #    const recode_ucs2 *pool;
    #    const short offset[256 / STRIP_SIZE];
    #  };
    #
    #struct ucs2_to_byte
    #  {
    #    recode_ucs2 code;              /* UCS-2 value */
    #    unsigned char byte;            /* corresponding byte */
    #  };
    #
    #struct ucs2_to_string
    #  {
    #    recode_ucs2 code;              /* UCS-2 value */
    #    unsigned short flags;  /* various flags */
    #    const char *string;            /* corresponding string */
    #  };
    #
    #/* Per module declarations.  */
    #
    ##ifdef __cplusplus
    #extern "C" {
    ##endif
    #
    #/* recode.c.  */
    #
    ##define ALLOC_SIZE(Variable, Size, Type) \
    #  (Variable = (Type *) recode_malloc (outer, (Size)), Variable)
    #
    ##define ALLOC(Variable, Count, Type) \
    #  ALLOC_SIZE (Variable, (Count) * sizeof (Type), Type)
    #
    ##define REALLOC(Variable, Count, Type) \
    #  (Variable = (Type *) recode_realloc (outer, Variable,            \
    #                                  (Count) * sizeof(Type)), \
    #   Variable)
    #
    #void recode_error PARAMS ((RECODE_OUTER, const char *, ...));
    #void recode_perror PARAMS ((RECODE_OUTER, const char *, ...));
    #void *recode_malloc PARAMS ((RECODE_OUTER, size_t));
    #void *recode_realloc PARAMS ((RECODE_OUTER, void *, size_t));
    #
    #unsigned char *invert_table PARAMS ((RECODE_OUTER, const unsigned char *));
    #bool complete_pairs PARAMS ((RECODE_OUTER, RECODE_STEP,
    #                        const struct recode_known_pair *, unsigned,
    #                        bool, bool));
    #bool transform_byte_to_ucs2 PARAMS ((RECODE_SUBTASK));
    #bool init_ucs2_to_byte PARAMS ((RECODE_STEP, RECODE_CONST_REQUEST,
    #                           RECODE_CONST_OPTION_LIST,
    #                           RECODE_CONST_OPTION_LIST));
    #bool transform_ucs2_to_byte PARAMS ((RECODE_SUBTASK));
    #
    #/* charname.c and fr-charname.c.  */
    #
    #const char *ucs2_to_charname PARAMS ((int));
    #const char *ucs2_to_french_charname PARAMS ((int));
    #
    #/* charset.c.  */
    #
    #enum alias_find_type
    #{
    #  SYMBOL_CREATE_CHARSET,   /* charset as given, create as needed */
    #  SYMBOL_CREATE_DATA_SURFACE,      /* data surface as given, create as needed */
    #  SYMBOL_CREATE_TREE_SURFACE,      /* tree surface as given, create as needed */
    #  ALIAS_FIND_AS_CHARSET,   /* disambiguate only as a charset */
    #  ALIAS_FIND_AS_SURFACE,   /* disambiguate only as a surface */
    #  ALIAS_FIND_AS_EITHER             /* disambiguate as a charset or a surface */
    #};
    #
    #int code_to_ucs2 (RECODE_CONST_SYMBOL, unsigned);
    #bool prepare_for_aliases PARAMS ((RECODE_OUTER));
    #RECODE_ALIAS declare_alias PARAMS ((RECODE_OUTER,
    #                                const char *, const char *));
    #bool declare_implied_surface PARAMS ((RECODE_OUTER, RECODE_ALIAS,
    #                               RECODE_CONST_SYMBOL));
    #bool make_argmatch_arrays PARAMS ((RECODE_OUTER));
    #RECODE_ALIAS find_alias PARAMS ((RECODE_OUTER, const char *,
    #                              enum alias_find_type));
    #bool find_and_report_subsets PARAMS ((RECODE_OUTER));
    #bool decode_known_pairs PARAMS ((RECODE_OUTER, const char *));
    #
    #/* combine.c.  */
    #
    ##define DONE NOT_A_CHARACTER
    ##define ELSE BYTE_ORDER_MARK_SWAPPED
    #
    #bool init_explode PARAMS ((RECODE_STEP, RECODE_CONST_REQUEST,
    #                      RECODE_CONST_OPTION_LIST,
    #                      RECODE_CONST_OPTION_LIST));
    #bool explode_byte_byte PARAMS ((RECODE_SUBTASK));
    #bool explode_ucs2_byte PARAMS ((RECODE_SUBTASK));
    #bool explode_byte_ucs2 PARAMS ((RECODE_SUBTASK));
    #bool explode_ucs2_ucs2 PARAMS ((RECODE_SUBTASK));
    #
    #bool init_combine PARAMS ((RECODE_STEP, RECODE_CONST_REQUEST,
    #                      RECODE_CONST_OPTION_LIST,
    #                      RECODE_CONST_OPTION_LIST));
    #bool combine_byte_byte PARAMS ((RECODE_SUBTASK));
    #bool combine_ucs2_byte PARAMS ((RECODE_SUBTASK));
    #bool combine_byte_ucs2 PARAMS ((RECODE_SUBTASK));
    #bool combine_ucs2_ucs2 PARAMS ((RECODE_SUBTASK));
    #
    #/* freeze.c.  */
    #
    #void recode_freeze_tables PARAMS ((RECODE_OUTER));
    #
    #/* libiconv.c.  */
    #
    #bool transform_with_libiconv PARAMS ((RECODE_SUBTASK));
    #
    #/* mixed.c.  */
    #
    #bool transform_c_source PARAMS ((RECODE_TASK));
    #bool transform_po_source PARAMS ((RECODE_TASK));
    #
    #/* outer.c.  */
    #
    #bool reversibility PARAMS ((RECODE_SUBTASK, unsigned));
    #RECODE_SINGLE declare_single
    #  PARAMS ((RECODE_OUTER, const char *, const char *,
    #      struct recode_quality,
    #      bool (*) (RECODE_STEP, RECODE_CONST_REQUEST,
    #                RECODE_CONST_OPTION_LIST, RECODE_CONST_OPTION_LIST),
    #      bool (*) (RECODE_SUBTASK)));
    #bool declare_libiconv PARAMS ((RECODE_OUTER, const char *));
    #bool declare_explode_data PARAMS ((RECODE_OUTER, const unsigned short *,
    #                              const char *, const char *));
    #bool declare_strip_data PARAMS ((RECODE_OUTER, struct strip_data *,
    #                            const char *));
    #
    #/* pool.c.  */
    #
    #extern const recode_ucs2 ucs2_data_pool[];
    #
    #/* request.c.  */
    #
    #char *edit_sequence PARAMS ((RECODE_REQUEST, bool));
    #
    #/* rfc1345.c.  */
    #
    #const char *ucs2_to_rfc1345 PARAMS ((recode_ucs2));
    #
    #/* task.c.  */
    #
    ##if USE_HELPERS
    #int get_byte_helper PARAMS ((RECODE_SUBTASK));
    ##endif
    #void put_byte_helper PARAMS ((int, RECODE_SUBTASK));
    #bool recode_if_nogo PARAMS ((enum recode_error, RECODE_SUBTASK));
    #bool transform_byte_to_byte PARAMS ((RECODE_SUBTASK));
    #bool transform_byte_to_variable PARAMS ((RECODE_SUBTASK));
    #
    #/* ucs.c.  */
    #
    #/* Replacement character for when correctly formed character has no
    #   equivalent.  It is not used for ill-formed characters, however.  */
    ##define REPLACEMENT_CHARACTER 0xFFFD
    #
    #/* Device for detecting if bytes are swapped.  This value should appear first
    #   in UCS-2 files.  */
    ##define BYTE_ORDER_MARK 0xFEFF
    ##define BYTE_ORDER_MARK_SWAPPED 0xFFFE
    #
    #/* Never an UCS-2 character.  */
    ##define NOT_A_CHARACTER 0xFFFF
    #
    #bool get_ucs2 PARAMS ((unsigned *, RECODE_SUBTASK));
    #bool get_ucs4 PARAMS ((unsigned *, RECODE_SUBTASK));
    #bool put_ucs2 PARAMS ((unsigned, RECODE_SUBTASK));
    #bool put_ucs4 PARAMS ((unsigned, RECODE_SUBTASK));
    #
    ##ifdef __cplusplus
    #}
    ##endif
    #
    #/* Global macros specifically for `recode'.  */
    #
    #/* Giving a name to the ASCII character assigned to position 0.  */
    ##define NUL '\0'
    #
    ##if USE_HELPERS
    #
    ## define get_byte(Subtask) \
    #    get_byte_helper ((Subtask))
    #
    ## define put_byte(Byte, Subtask) \
    #    put_byte_helper ((Byte), (Subtask))
    #
    ##else /* not USE_HELPERS */
    #
    ## define get_byte(Subtask) \
    #    ((Subtask)->input.file                                 \
    #     ? getc ((Subtask)->input.file)                                \
    #     : (Subtask)->input.cursor == (Subtask)->input.limit   \
    #     ? EOF                                                 \
    #     : (unsigned char) *(Subtask)->input.cursor++)
    #
    ## define put_byte(Byte, Subtask) \
    #    ((Subtask)->output.file                                        \
    #     ? (putc ((char) (Byte), (Subtask)->output.file), 0)   \
    #     : (Subtask)->output.cursor == (Subtask)->output.limit \
    #     ? (put_byte_helper ((int) (Byte), (Subtask)), 0)              \
    #     : (*(Subtask)->output.cursor++ = (Byte), 0))
    #
    ##endif /* not USE_HELPERS */
    #
    ##ifdef FLEX_SCANNER
    #
    ## if !INLINE_HARDER
    #
    ##  undef put_byte
    ##  define put_byte(Byte, Subtask) \
    #     put_byte_helper ((Byte), (Subtask))
    #
    ## endif
    #
    ## define PUT_NON_DIACRITIC_BYTE(Byte, Subtask) \
    #    if (request->diacritics_only)                          \
    #      ECHO;                                                        \
    #    else                                                   \
    #      put_byte ((Byte), (Subtask))
    #
    #/* ECHO may not have a (Subtask) argument, because some ECHO without argument
    #   is generated by Flex -- yet Vern tells me it won't happen if I inhibit
    #   the rule about default copying.  Happily enough, within Flex, Subtask is
    #   `subtask' quite systematically, so it may be used as a constant, here.  */
    ## define ECHO \
    #    do {                                                   \
    #      const char *cursor = yytext; int counter = yyleng;   \
    #      for (; counter > 0; cursor++, counter--)                     \
    #   put_byte (*cursor, subtask);                            \
    #    } while (false)
    #
    ##endif /* FLEX_SCANNER */

class error(Exception):
    pass

# Description of list formats.

NO_FORMAT = RECODE_NO_FORMAT
DECIMAL_FORMAT = RECODE_DECIMAL_FORMAT
OCTAL_FORMAT = RECODE_OCTAL_FORMAT
HEXADECIMAL_FORMAT = RECODE_HEXADECIMAL_FORMAT
FULL_FORMAT = RECODE_FULL_FORMAT

# Description of programming languages.

NO_LANGUAGE = RECODE_NO_LANGUAGE
LANGUAGE_C = RECODE_LANGUAGE_C
LANGUAGE_PERL = RECODE_LANGUAGE_PERL

# Recode library at OUTER level.

cdef class Outer:
    cdef RECODE_OUTER outer

    def __init__(self):
        self.outer = recode_new_outer(true)

    def __dealloc__(self):
        recode_delete_outer(self.outer)

    def all_symbols(self):
        ok = list_all_symbols(self.outer, NULL)
        if not ok:
            raise error

    def concise_charset(self, format=NO_FORMAT):
        ok = list_concise_charset(self.outer, NULL, format)
        if not ok:
            raise error

    def full_charset(self):
        ok = list_full_charset(self.outer, NULL)
        if not ok:
            raise error

# Recode library at REQUEST level.

cdef class Request:
    cdef RECODE_REQUEST request

    def __init__(self, Outer outer):
        self.request = recode_new_request(outer.outer)

    def __dealloc__(self):
        recode_delete_request(self.request)

    def scan_request(self, char *text):
        ok = recode_scan_request(self.request, text)
        if not ok:
            raise error

    def format_table(self, int language, char *charset):
        ok = recode_format_table(
                self.request, <recode_programming_language> language, charset)
        if not ok:
            raise error

    def string(self, char *text):
        cdef char *result
        result = recode_string(self.request, text)
        if result is NULL:
            raise error
        return result

    #bool recode_string_to_buffer(
    #        RECODE_CONST_REQUEST, char *, char **, size_t *, size_t *)
    #bool recode_string_to_file(
    #        RECODE_CONST_REQUEST, char *, FILE *)
    #bool recode_buffer_to_buffer(
    #        RECODE_CONST_REQUEST, char *, size_t, char **, size_t *, size_t *)
    #bool recode_buffer_to_file(
    #        RECODE_CONST_REQUEST, char *, size_t, FILE *)
    #bool recode_file_to_buffer(
    #        RECODE_CONST_REQUEST, FILE *, char **, size_t *, size_t *)
    #bool recode_file_to_file(RECODE_CONST_REQUEST, FILE *, FILE *)

# Lazy, all in one call.

global_outer = Outer()

def recode(char *text, char *string):
    request = Request(global_outer)
    request.scan_request(text)
    return request.string(string)