/*
	Copyright 2022 Mohamed Shalan
	
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

`timescale          1ns/1ns
`default_nettype    none

module AHBL_BUS_8 #(parameter   BAD_DATA=32'DEADBEEF,
                                SLAVE_ENABLE=8'hff, 
                                S0_PAGE=8'h00,
                                S1_PAGE=8'h00,
                                S2_PAGE=8'h00,
                                S3_PAGE=8'h00,
                                S4_PAGE=8'h00,
                                S5_PAGE=8'h00,
                                S6_PAGE=8'h00,
                                S7_PAGE=8'h00 
) (
    input wire          HCLK,
    input wire          HRESETn,

    // Master Interface
    input wire  [31:0]  HADDR,
    input wire  [31:0]  HWDATA, 
    output wire [31:0]  HRDATA,
    output wire         HREADY,

    // Slave # 0
    output wire         HSEL_S0,
    input wire          HREADY_S0,
    input wire  [31:0]  HRDATA_S0,
    // Slave # 1
    output wire         HSEL_S1,
    input wire          HREADY_S1,
    input wire  [31:0]  HRDATA_S1,
    // Slave # 2
    output wire         HSEL_S2,
    input wire          HREADY_S2,
    input wire  [31:0]  HRDATA_S2,
    // Slave # 3
    output wire         HSEL_S3,
    input wire          HREADY_S3,
    input wire  [31:0]  HRDATA_S3,
    // Slave # 4
    output wire         HSEL_S4,
    input wire          HREADY_S4,
    input wire  [31:0]  HRDATA_S4,
    // Slave # 5
    output wire         HSEL_S5,
    input wire          HREADY_S5,
    input wire  [31:0]  HRDATA_S5,
    // Slave # 6
    output wire         HSEL_S6,
    input wire          HREADY_S6,
    input wire  [31:0]  HRDATA_S6,
    // Slave # 7
    output wire         HSEL_S7,
    input wire          HREADY_S7,
    input wire  [31:0]  HRDATA_S7
);
    wire    [7:0]   PAGE = HADDR[31:24];
    wire    [7:0]   HSEL = { HSEL_S7, HSEL_S6, HSEL_S5, HSEL_S4, HSEL_S3, HSEL_S2, HSEL_S1, HSEL_S0 };
    reg     [7:0]   AHSEL;

    always@ (posedge HCLK or negedge HRESETn) begin
    if(HREADY)
        AHSEL <= HSEL;
    end

    assign HSEL_S0 = (PAGE == S0_PAGE) & SLAVE_ENABLE[0];
    assign HSEL_S1 = (PAGE == S1_PAGE) & SLAVE_ENABLE[1];
    assign HSEL_S2 = (PAGE == S2_PAGE) & SLAVE_ENABLE[2];
    assign HSEL_S3 = (PAGE == S3_PAGE) & SLAVE_ENABLE[3];
    assign HSEL_S4 = (PAGE == S4_PAGE) & SLAVE_ENABLE[4];
    assign HSEL_S5 = (PAGE == S5_PAGE) & SLAVE_ENABLE[5];
    assign HSEL_S6 = (PAGE == S6_PAGE) & SLAVE_ENABLE[6];
    assign HSEL_S7 = (PAGE == S7_PAGE) & SLAVE_ENABLE[7];

    assign HREADY =
        AHSEL[0] ? HREADY_S0 :
        AHSEL[1] ? HREADY_S1 :
        AHSEL[2] ? HREADY_S2 :
        AHSEL[3] ? HREADY_S3 :
        AHSEL[4] ? HREADY_S4 :
        AHSEL[5] ? HREADY_S5 :
        AHSEL[6] ? HREADY_S6 :
        AHSEL[7] ? HREADY_S7 :
        1'b1;

    assign HRDATA =
        AHSEL[0] ? HRDATA_S0 :
        AHSEL[1] ? HRDATA_S1 :
        AHSEL[2] ? HRDATA_S2 :
        AHSEL[3] ? HRDATA_S3 :
        AHSEL[4] ? HRDATA_S4 :
        AHSEL[5] ? HRDATA_S5 :
        AHSEL[6] ? HRDATA_S6 :
        AHSEL[7] ? HRDATA_S7 :
        32'hDEADBEEF;

endmodule
