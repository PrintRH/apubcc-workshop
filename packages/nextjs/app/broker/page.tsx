"use client";

import React, { useState } from "react";
import { formatEther } from "viem";
import { IntegerInput } from "~~/components/scaffold-eth";
import { useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const BrokerPage = () => {
  const [amountValue, setAmountValue] = useState<string | bigint>("");
  const { writeContractAsync: writeApuBrokerAsync } = useScaffoldWriteContract("ApuBroker");

  const { data: apuTokenBalance } = useScaffoldReadContract({
    contractName: "ApuBroker",
    functionName: "getApuTokenBalance",
  });

  return (
    <div style={{ display: "flex", justifyContent: "center", marginTop: "20rem" }}>
      <div className="card bg-base-100 w-96 shadow-xl border border-[#05DFF9]">
        <div className="card-body">
          <h2 className="card-title justify-center">APU Token Broker</h2>
          <IntegerInput
            value={amountValue}
            onChange={updatedValue => {
              setAmountValue(updatedValue);
            }}
            placeholder="Enter amount in ETH and hit (*)"
          />
          <span className="text-sm text-center -mt-2">
            APU Broker Balance: {apuTokenBalance !== undefined ? formatEther(apuTokenBalance) : "Loading..."} Tokens{" "}
          </span>
          <button
            className="btn btn-primary"
            onClick={async () => {
              try {
                await writeApuBrokerAsync({
                  functionName: "buyApuTokens",
                  value: typeof amountValue === "string" ? BigInt(amountValue) : amountValue,
                });
              } catch (e) {
                console.error("Error setting greeting:", e);
              }
            }}
          >
            Buy APU Tokens
          </button>
        </div>
      </div>
    </div>
  );
};

export default BrokerPage;
