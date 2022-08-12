// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Payments, ABDKMathQuad} from "../SmartContracts/libs.sol";

contract HaveXStaking {
    function apy(uint256 principal, uint256 period)
        public
        pure
        returns (uint256)
    {
        //uint256 div = 5/100;
        return (principal / 100) * period;
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 z
    ) internal pure returns (uint256) {
        return
            ABDKMathQuad.toUInt(
                ABDKMathQuad.div(
                    ABDKMathQuad.mul(
                        ABDKMathQuad.fromUInt(x),
                        ABDKMathQuad.fromUInt(y)
                    ),
                    ABDKMathQuad.fromUInt(z)
                )
            );
    }

    function apyy() external pure returns (uint256) {
        return mulDiv(5, 233, 10^9);
    }
}
