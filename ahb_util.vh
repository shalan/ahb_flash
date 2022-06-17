/*
	Copyright 2020 Mohamed Shalan

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at:

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

`define     SLAVE_OFF_BITS   last_HADDR[7:0]

`define AHB_REG(name, size, offset, init)   \
        reg [size-1:0] name; \
        wire ``name``_sel = wr_enable & (`SLAVE_OFF_BITS == offset); \
        always @(posedge HCLK or negedge HRESETn) \
            if (~HRESETn) \
                ``name`` <= 'h``init``; \
            else if (``name``_sel) \
                ``name`` <= HWDATA[``size``-1:0];\

`define REG_FIELD(reg_name, fld_name, from, to)\
    wire [``to``-``from``:0] ``reg_name``_``fld_name`` = reg_name[to:from]; 

`define AHB_READ assign HRDATA = 

`define AHB_REG_READ(name, offset) (`SLAVE_OFF_BITS == offset) ? name : 

`define AHB_SLAVE_IFC   \
    input wire          HSEL,\
    input wire [31:0]   HADDR,\
    input wire [1:0]    HTRANS,\
    input wire          HWRITE,\
    input wire          HREADY,\
    input wire [31:0]   HWDATA,\
    input wire [2:0]    HSIZE,\
    output wire         HREADYOUT,\
    output wire [31:0]  HRDATA

`define AHB_SLAVE_RO_IFC   \
    input               HSEL,\
    input wire [31:0]   HADDR,\
    input wire [1:0]    HTRANS,\
    input wire          HWRITE,\
    input wire          HREADY,\
    input wire [2:0]    HSIZE,\
    output wire         HREADYOUT,\
    output wire [31:0]  HRDATA

`define AHB_SLAVE_BUS_IFC(prefix)   \
    output wire        ``prefix``_HSEL,\
    input wire         ``prefix``_HREADYOUT,\
    input wire [31:0]  ``prefix``_HRDATA

`define AHB_SLAVE_SIGNALS(prefix)\
    wire         ``prefix``_HSEL;\
    wire         ``prefix``_HREADYOUT;\
    wire [31:0]  ``prefix``_HRDATA;    

`define AHB_SLAVE_CONN(prefix)   \
        .``prefix``_HSEL(``prefix``_HSEL),\
        .``prefix``_HADDR(HADDR),\
        .``prefix``_HTRANS(HTRANS),\
        .``prefix``_HWRITE(HWRITE),\
        .``prefix``_HREADY(HREADY),\
        .``prefix``_HWDATA(HWDATA),\
        .``prefix``_HSIZE(HSIZE),\
        .``prefix``_HREADYOUT(``prefix``_HREADYOUT),\
        .``prefix``_HRDATA(``prefix``_HRDATA)

`define AHB_SLAVE_BUS_CONN(prefix)   \
        .``prefix``_HSEL(``prefix``_HSEL),\
        .``prefix``_HREADYOUT(``prefix``_HREADYOUT),\
        .``prefix``_HRDATA(``prefix``_HRDATA)

`define AHB_SLAVE_INST_CONN(prefix)   \
        .HSEL(``prefix``_HSEL),\
        .HADDR( HADDR),\
        .HTRANS(HTRANS),\
        .HWRITE(HWRITE),\
        .HREADY(HREADY),\
        .HWDATA(HWDATA),\
        .HSIZE( HSIZE),\
        .HREADYOUT(``prefix``_HREADYOUT),\
        .HRDATA(``prefix``_HRDATA)

`define AHB_SLAVE_INST_CONN_NP   \
        .HSEL(HSEL),\
        .HADDR( HADDR),\
        .HTRANS(HTRANS),\
        .HWRITE(HWRITE),\
        .HREADY(HREADY),\
        .HWDATA(HWDATA),\
        .HSIZE( HSIZE),\
        .HREADYOUT(HREADYOUT),\
        .HRDATA(HRDATA)

`define AHB_MASTER_IFC(prefix) \
    output wire [31:0]  HADDR,\
    output wire [1:0]   HTRANS,\
    output wire [2:0] 	HSIZE,\
    output wire         HWRITE,\
    output wire [31:0]  HWDATA,\
    input wire          HREADY,\
    input wire [31:0]   HRDATA 

`define AHB_MASTER_BUS_IFC(prefix) \
    input wire [31:0]   HADDR,\
    input wire [1:0]    HTRANS,\
    input wire [2:0]    HSIZE,\
    input wire          HWRITE,\
    input wire [31:0]   HWDATA,\
    output wire         HREADY,\
    output wire [31:0]  HRDATA 

`define AHB_MASTER_BUS_IFC_NP \
    input wire [31:0]   HADDR,\
    input wire [1:0]    HTRANS,\
    input wire [2:0]    HSIZE,\
    input wire          HWRITE,\
    input wire [31:0]   HWDATA,\
    output wire         HREADY,\
    output wire [31:0]  HRDATA 

`define AHB_MASTER_CONN_NP \
        .HADDR( HADDR),\
        .HTRANS(HTRANS),\
        .HSIZE( HSIZE),\
        .HWRITE(HWRITE),\
        .HWDATA(HWDATA),\
        .HREADY(HREADY),\
        .HRDATA(HRDATA) 

`define AHB_MASTER_CONN(prefix) \
        .``prefix``_HADDR( HADDR),\
        .``prefix``_HTRANS(HTRANS),\
        .``prefix``_HSIZE( HSIZE),\
        .``prefix``_HWRITE(HWRITE),\
        .``prefix``_HWDATA(HWDATA),\
        .``prefix``_HREADY(HREADY),\
        .``prefix``_HRDATA(HRDATA) 


`define AHB_MASTER_SIGNALS(prefix) \
    wire [31:0]  ``prefix``_HADDR;\
    wire [1:0]   ``prefix``_HTRANS;\
    wire [2:0] 	 ``prefix``_HSIZE;\
    wire         ``prefix``_HWRITE;\
    wire [31:0]  ``prefix``_HWDATA;\
    wire         ``prefix``_HREADY;\
    wire [31:0]  ``prefix``_HRDATA; 


`define AHB_SLAVE_EPILOGUE \
    reg             last_HSEL; \
    reg [31:0]      last_HADDR; \
    reg             last_HWRITE; \
    reg [1:0]       last_HTRANS; \
    \
    always@ (posedge HCLK) begin\
        if(HREADY) begin\
            last_HSEL       <= HSEL;   \
            last_HADDR      <= HADDR;  \
            last_HWRITE     <= HWRITE; \
            last_HTRANS     <= HTRANS; \
        end\
    end\
    \
    wire rd_enable = last_HSEL & (~last_HWRITE) & last_HTRANS[1]; \
    wire wr_enable = last_HSEL & (last_HWRITE) & last_HTRANS[1];


`define     SLAVE_SIGNAL(signal, indx)    S``indx``_``signal``
`define     AHB_SYS_EPILOGUE(DEC_BITS, DEC_BITS_CNT, NUM_SLAVES) \    
    wire [DEC_BITS_CNT-1:0]     PAGE = HADDR[DEC_BITS]; \
    reg  [DEC_BITS_CNT-1:0]     APAGE;\
    wire [NUM_SLAVES-1:0]       AHSEL;\
    always@ (posedge HCLK or negedge HRESETn) begin \
    if(!HRESETn)\
        APAGE <= DEC_BITS_CNT'h0;\
    else if(HREADY)\
        APAGE <= PAGE;\
    end

`define ADD_AHB_SLAVE(SLAVE_ID)\
    assign ``SLAVE_ID``_HSEL    = (PAGE     == ``SLAVE_ID``_PAGE);\
    wire ``SLAVE_ID``_AHSEL   = (APAGE    == ``SLAVE_ID``_PAGE);

`define AHB_MUX\
    assign {HREADY, HRDATA} =

`define AHB_MUX_SLAVE(SLAVE_ID)\
    (``SLAVE_ID``_AHSEL) ? {``SLAVE_ID``_HREADYOUT, ``SLAVE_ID``_HRDATA} :

`define AHB_MUX_DEFAULT\
    {1'b1, 32'hFEADBEEF};\


// AHB Master Port w/ a prefix
`define AHB_MASTER_PORT(P)\
    output wire [31:0]  ``P``_HADDR,\
    output wire [1:0]   ``P``_HTRANS,\
    output wire [2:0] 	``P``_HSIZE,\
    output wire         ``P``_HWRITE,\
    output wire [31:0]  ``P``_HWDATA,\
    input wire          ``P``_HREADY,\
    input wire [31:0]   ``P``_HRDATA 

// AHB Master Port w/o a prefix
`define AHB_MASTER_PORT_NP\
    output wire [31:0]  HADDR,\
    output wire [1:0]   HTRANS,\
    output wire [2:0] 	HSIZE,\
    output wire         HWRITE,\
    output wire [31:0]  HWDATA,\
    input wire          HREADY,\
    input wire [31:0]   HRDATA 
/*
`define AHB_MASTER_PORT_CONN(PP, PI)\
        .``PP``_HADDR(``PI``_HADDR),\
        .``PP``_HTRANS(``PI``_HTRANS),\
        .``PP``_HSIZE(``PI``_HSIZE),\
        .``PP``_HWRITE(``PI``_HWRITE),\
        .``PP``_HWDATA(``PI``_HWDATA),\
        .``PP``_HREADY(``PI``_HREADY),\
        .``PP``_HRDATA(``PI``_HRDATA) 

*/
`define AHB_MASTER_PORT_CONN_NP\
        .HADDR(HADDR),\
        .HTRANS(HTRANS),\
        .HSIZE(HSIZE),\
        .HWRITE(HWRITE),\
        .HWDATA(HWDATA),\
        .HREADY(HREADY),\
        .HRDATA(HRDATA) 
/*
`define AHB_MASTER_SIG(P)\
    wire [31:0]  ``p``_HADDR;\
    wire [1:0]   ``p``_HTRANS;\
    wire [2:0] 	 ``p``_HSIZE;\
    wire         ``p``_HWRITE;\
    wire [31:0]  ``p``_HWDATA;\
    wire         ``p``_HREADY;\
    wire [31:0]  ``p``_HRDATA; 

`define AHB_MASTER_SIG_NP\
    wire [31:0]  HADDR;\
    wire [1:0]   HTRANS;\
    wire [2:0] 	 HSIZE;\
    wire         HWRITE;\
    wire [31:0]  HWDATA;\
    wire         HREADY;\
    wire [31:0]  HRDATA; 


`define AHB_SLAVE_PORT(P)\
    input wire          ``P_``HSEL,\
    input wire [31:0]   ``P_``HADDR,\
    input wire [1:0]    ``P_``HTRANS,\
    input wire          ``P_``HWRITE,\
    input wire          ``P_``HREADY,\
    input wire [31:0]   ``P_``HWDATA,\
    input wire [2:0]    ``P_``HSIZE,\
    output wire         ``P_``HREADYOUT,\
    output wire [31:0]  ``P_``HRDATA

`define AHB_SLAVE_PORT_NP\
    input wire          HSEL,\
    input wire [31:0]   HADDR,\
    input wire [1:0]    HTRANS,\
    input wire          HWRITE,\
    input wire          HREADY,\
    input wire [31:0]   HWDATA,\
    input wire [2:0]    HSIZE,\
    output wire         HREADYOUT,\
    output wire [31:0]  HRDATA
*/
`define AHB_SLAVE_BUS_PORT(P)   \
    output wire        ``P``_HSEL,\
    input wire         ``P``_HREADYOUT,\
    input wire [31:0]  ``P``_HRDATA
/*
`define AHB_SLAVE_PORT_CONN(PP, PI)\
        .``PP``_HSEL(``PI``_HSEL),\
        .``PP``_HADDR(``PI``_HADDR),\
        .``PP``_HTRANS(``PI``_HTRANS),\
        .``PP``_HWRITE(``PI``_HWRITE),\
        .``PP``_HREADY(``PI``_HREADY),\
        .``PP``_HWDATA(``PI``_HWDATA),\
        .``PP``_HSIZE(``PI``_HSIZE),\
        .``PP``_HREADYOUT(``PI``_HREADYOUT),\
        .``PP``_HRDATA(``PI``_HRDATA)

`define AHB_SLAVE_PORT_CONN_NP\
        .HSEL(HSEL),\
        .HADDR(HADDR),\
        .HTRANS(HTRANS),\
        .HWRITE(HWRITE),\
        .HREADY(HREADY),\
        .HWDATA(HWDATA),\
        .HSIZE(HSIZE),\
        .HREADYOUT(HREADYOUT),\
        .HRDATA(HRDATA)

`define AHB_SLAVE_BUS_CONN(P)\
        .P``_HSEL(``P``_HSEL),\
        .P``_HREADYOUT(``P``_HREADYOUT),\
        .P``_HRDATA(``P``_HRDATA)
*/
`define AHB_SLAVE_INST_CONN_P(PP, PI)\
        .``PP``_HSEL(``PI``_HSEL),\
        .``PP``_HADDR( HADDR),\
        .``PP``_HTRANS(HTRANS),\
        .``PP``_HWRITE(HWRITE),\
        .``PP``_HREADY(HREADY),\
        .``PP``_HWDATA(HWDATA),\
        .``PP``_HSIZE( HSIZE),\
        .``PP``_HREADYOUT(``PI``_HREADYOUT),\
        .``PP``_HRDATA(``PI``_HRDATA)
/*
`define AHB_SLAVE_SIG(P)\
    wire          ``P``_HSEL;\
    wire [31:0]   ``P``_HADDR;\
    wire [1:0]    ``P``_HTRANS;\
    wire          ``P``_HWRITE;\
    wire          ``P``_HREADY;\
    wire [31:0]   ``P``_HWDATA;\
    wire [2:0]    ``P``_HSIZE;\
    wire          ``P``_HREADYOUT;\
    wire [31:0]   ``P``_HRDATA;

`define AHB_SLAVE_SIG_NP\
    wire          HSEL;\
    wire [31:0]   HADDR;\
    wire [1:0]    HTRANS;\
    wire          HWRITE;\
    wire          HREADY;\
    wire [31:0]   HWDATA;\
    wire [2:0]    HSIZE;\
    wire          HREADYOUT;\
    wire [31:0]   HRDATA;

`define AHB_SLAVE_INST_SIG(P)\
    wire         ``P``_HSEL;\
    wire         ``P``_HREADYOUT;\
    wire [31:0]  ``P``_HRDATA; 
*/
`define AHB_CLK_RST\
    input wire HCLK,\
    input wire HRESETn

`define AHB_CLK_RST_CONN\
    .HCLK(HCLK),\
    .HRESETn(HRESETn)
