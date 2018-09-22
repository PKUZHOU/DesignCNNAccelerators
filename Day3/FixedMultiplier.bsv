/******************************************************************************
Author: Hyoukjun Kwon (hyoukjun@gatech.edu)

Copyright (c) 2017 Georgia Instititue of Technology

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*******************************************************************************/

import Fifo::*;
import FixedTypes::*;

(* synthesize *)
module mkFixedMultiplier(FixedALU);
  Fifo#(1, FixedPoint) argA <- mkPipelineFifo;
  Fifo#(1, FixedPoint) argB <- mkPipelineFifo;

  Fifo#(1, FixedPoint) res <- mkBypassFifo;

  rule doMultiplication;
    let operandA = argA.first;
    let operandB = argB.first;
    argA.deq;
    argB.deq;

    Bit#(32) extendedA = signExtend(operandA);
    Bit#(32) extendedB = signExtend(operandB);

    Bit#(32) extendedRes = extendedA * extendedB;

    FixedPoint resValue = {extendedRes[31], extendedRes[26:24], extendedRes[23:12]};

    res.enq(resValue);
  endrule

  method Action putArgA(FixedPoint newArg);
    argA.enq(newArg);
  endmethod

  method Action putArgB(FixedPoint newArg);
    argB.enq(newArg);
  endmethod

  method ActionValue#(FixedPoint) getRes;
    res.deq;
    return res.first;
  endmethod

endmodule
